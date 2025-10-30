# 🧠 Mechanics Sonar — Análise de Código e Segurança

![SonarQube](https://img.shields.io/badge/SonarQube-Analysis-blue?logo=sonarqube&logoColor=white)
![OWASP](https://img.shields.io/badge/OWASP-Security%20Check-orange?logo=owasp&logoColor=white)
![.NET](https://img.shields.io/badge/.NET-8.0-blueviolet?logo=dotnet)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)

---

## 🧾 Sobre o projeto

Executa análises no código do projeto [Meachnics-13SOAT](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/Mechanics-13soat).

O **Mechanics Sonar** é um projeto auxiliar responsável por automatizar a análise de qualidade e segurança de código de outros repositórios.
Executada por meio de um script (.bat) que realiza todo o processo de forma integrada.

O código analisado pertence a outro projeto, adicionado como submódulo Git, permitindo que o Mechanics Sonar execute a varredura completa — incluindo métricas de qualidade, cobertura de testes e detecção de vulnerabilidades — sem alterar o código-fonte original.

Este guia descreve como configurar o ambiente, executar a análise e visualizar os relatórios de resultados no SonarQube e no OWASP.

---

## 🧰 Pré-requisitos

Antes de iniciar, verifique se você possui instalado:

- 🐳 [Docker](https://docs.docker.com/get-docker/)
- 🟣 [.NET SDK 8.0+](https://dotnet.microsoft.com/en-us/download)
- ☕ [Java Runtime](https://www.java.com/pt-BR/download)

---

## 🚀 Passo a passo da análise

### **1️⃣ Subir o container do SonarQube**

Na raiz do projeto, execute:

```bash
docker-compose up -d
```

Aguarde até que o container **SonarQube** esteja completamente inicializado.

---

### **2️⃣ Acessar o painel do SonarQube**

Abra o navegador e acesse:

🔗 [http://localhost:9000](http://localhost:9000)

---

### **3️⃣ Fazer login com credenciais padrão**

```
Usuário: admin
Senha: admin
```

Após o primeiro login, o SonarQube solicitará a redefinição da senha.  
Defina uma nova senha e prossiga.

---

### **4️⃣ Criar o token de autenticação**

Acesse a página de geração de tokens:

🔗 [http://localhost:9000/account/security](http://localhost:9000/account/security)

Depois:

- Clique em **"Generate Tokens"**
- Nomeie o token como: `fiap-mechanics`
- Copie o token gerado (ele será usado no próximo passo)

⚠️ **Atenção:** o token só é exibido uma vez — guarde-o temporariamente para uso imediato.

---

### **5️⃣ Executar o script de análise**

Com o SonarQube ativo e o token em mãos, rode:

```bash
run-scanner.bat <SONAR_TOKEN>
```

Substitua `<SONAR_TOKEN>` pelo token criado no passo anterior.

---

### **6️⃣ Verificar os resultados da análise**

Após a conclusão, acesse novamente o SonarQube:

🔗 [http://localhost:9000](http://localhost:9000)

Você poderá visualizar:

- ✅ Cobertura de testes  
- 🧩 Duplicações de código  
- 🐞 Vulnerabilidades  
- ⚠️ Code Smells  
- 🔒 Problemas de segurança  

---

### **7️⃣ Acessar o relatório OWASP**

O relatório detalhado de vulnerabilidades será gerado em:

```
owasp/report/dependency-check-report.html
```

Abra esse arquivo no navegador para visualizar as dependências e suas respectivas vulnerabilidades.

---

## 🛠️ Ferramentas utilizadas

| Ferramenta | Função principal |
|-------------|------------------|
| 🧠 **SonarQube** | Análise estática de código e métricas de qualidade |
| 🛡️ **OWASP Dependency Check** | Verificação de vulnerabilidades em dependências |
| 🧪 **.NET Test + OpenCover** | Execução de testes e geração de cobertura |
| 🐳 **Docker Compose** | Orquestração dos containers |
| ⚙️ **Sonar Scanner for .NET** | Envio de relatórios ao SonarQube |