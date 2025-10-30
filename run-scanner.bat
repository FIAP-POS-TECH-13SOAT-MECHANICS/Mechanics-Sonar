@echo off
setlocal enabledelayedexpansion

REM Valida se o token foi recebido
if "%~1"=="" (
    echo ERRO: Token do SonarQube nao fornecido!
    echo Uso: %~nx0 ^<SONAR_TOKEN^>
    exit /b 1
)

set SONAR_TOKEN=%~1

REM Valida dependencias e submodulo
set DEPENDENCIES_OK=1

where java >nul 2>&1
if errorlevel 1 (
    echo Java nao instalado!
    set DEPENDENCIES_OK=0
)

where dotnet >nul 2>&1
if errorlevel 1 (
    echo Dotnet SDK 8 nao instalado!
    set DEPENDENCIES_OK=0
)

dotnet tool list -g 2>nul | findstr "dotnet-sonarscanner" >nul 2>&1
if errorlevel 1 (
    echo Dotnet SonarScanner nao instalado!
    echo Use 'dotnet tool install --global dotnet-sonarscanner' para instalar.
    set DEPENDENCIES_OK=0
)

docker info >nul 2>&1
if errorlevel 1 (
    echo Docker Desktop nao esta em execucao!
    echo Inicie o Docker Desktop e aguarde ate que esteja pronto.
    set DEPENDENCIES_OK=0
)

if not exist "project\" (
    echo Submodulo nao carregado!
    echo Use 'git submodule update --init --recursive' para baixar o projeto.
    set DEPENDENCIES_OK=0
) else (
    dir /b "project\" 2>nul | findstr "^" >nul 2>&1
    if errorlevel 1 (
        echo Submodulo nao carregado!
        echo Use 'git submodule update --init --recursive' para baixar o projeto.
        set DEPENDENCIES_OK=0
    )
)

if !DEPENDENCIES_OK!==0 (
    echo ERRO: Dependencias faltando!
    echo Corrija os erros e tente novamente.
    exit /b 2
)

echo ===========================================
echo --- Iniciando analise OWASP + SonarQube ---
echo KEY: fiap-mechanics
echo URL: http://localhost:9000
echo ===========================================
echo.

echo --- Executando analise OWASP ---
echo.

docker run ^
  --name fiap-sonar-owasp ^
  --rm ^
  -e TZ=America/Sao_Paulo ^
  -v ./project/src:/src ^
  -v ./owasp/dependency-check-data:/usr/share/dependency-check/data ^
  -v ./owasp:/data ^
  owasp/dependency-check:latest ^
    --scan /src ^
    --project fiap-mechanics ^
    --out /data/report ^
    --format "ALL" ^
    --enableExperimental ^
    --disableRetireJS ^
    --suppression /data/suppression.xml

rmdir /s /q TestResults
if not exist "TestResults" mkdir "TestResults"

echo --- Executando analise SonarQube ---
echo.

dotnet-sonarscanner begin ^
  /k:fiap-mechanics ^
  /d:sonar.host.url=http://localhost:9000 ^
  /d:sonar.token=%SONAR_TOKEN% ^
  /d:sonar.cs.opencover.reportsPaths=TestResults/**/coverage.opencover.xml ^
  /d:sonar.coverage.exclusions=**/Migrations/**,**/Program.cs ^
  /d:sonar.dependencyCheck.reportPath=/owasp/dependency-check-report.xml ^
  /d:sonar.dependencyCheck.htmlReportPath=/owasp/dependency-check-report.html ^
  /d:sonar.dependencyCheck.jsonReportPath=/owasp/dependency-check-report.json

if errorlevel 1 exit /b 3

dotnet restore project\Fiap.Mechanics.sln
if errorlevel 1 exit /b 3

dotnet build project\Fiap.Mechanics.sln --no-incremental
if errorlevel 1 exit /b 3

echo.
echo --- Executando testes e gerando cobertura ---
dotnet test project\Fiap.Mechanics.sln ^
  --collect:"XPlat Code Coverage;Format=opencover" ^
  --results-directory "TestResults" ^
  --logger "trx;LogFileName=testresults.trx"

if errorlevel 1 exit /b 3

echo.
echo --- Arquivos de cobertura gerados ---
dir /s /b "TestResults\*\*coverage*" 2>nul || echo Nenhum arquivo de cobertura encontrado.

dotnet-sonarscanner end /d:sonar.token=%SONAR_TOKEN%

endlocal