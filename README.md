# Mechanics - Análises SonarQube

Executa análises no código do projeto [Meachnics-13SOAT](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/Mechanics-13soat).

## Configuração

1. Suba o container do Sonar: `docker-compose up -d` e aguarde
2. Faça login utilizando a senha padrão `admin`
3. Acesse [My account](http://localhost:9000/account/security) e crie um novo token de acesso com o nome `fiap-mechanics`
4. Execute o script [run-scanner.bat <token>](run-scanner.bat)
5. O relatório OWASP estará disponível em [owasp/report/dependency-check-report.html](owasp/report/dependency-check-report.html)
6. Os resultados da análise do SonarQube aparecem no [painel do projeto](http://localhost:9000/dashboard?id=fiap-mechanics)
