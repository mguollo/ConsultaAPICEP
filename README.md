# 🔍 ConsultaCEP - Delphi

Aplicação desenvolvida em **Delphi** para consulta de endereços através de CEP ou Endereço Completo, utilizando a API **ViaCEP** e persistência local em **SQLite**.  

O sistema segue boas práticas de arquitetura, separação de responsabilidades e inclui testes unitários com **DUnit**.

---

## 🚀 Funcionalidades

- Consulta de endereço por **CEP**  
- Consulta de endereço por **Endereço Completo** (Estado + Cidade + Logradouro)  
- Validação mínima de campos (≥ 3 caracteres)  
- Cache local em **SQLite** para evitar consultas repetidas à API  
- Opção de atualizar ou reutilizar dados já armazenados  
- Testes unitários cobrindo:
  - Validação de CEP (`uCepHelper`)
  - Parsing de JSON/XML (`uViaCepService`)
  - Classe de modelo (`uAddress`)
  - Repositório com SQLite (`uAddressRepository`)

---

## 🏗️ Arquitetura

A aplicação foi estruturada em **camadas**:

```
📦 ConsultaCEP
 ┣ 📂 Source
 ┃ ┣ 📄 uFrmMain.pas           # UI principal
 ┃ ┣ 📄 uAddress.pas           # Classe de domínio (Entidade)
 ┃ ┣ 📄 uAddressRepository.pas # Repositório (CRUD em SQLite)
 ┃ ┣ 📄 uViaCepService.pas     # Serviço ViaCEP (JSON/XML)
 ┃ ┣ 📄 uIViaCepService.pas    # Interface para abstração do serviço
 ┃ ┣ 📄 uCepHelper.pas         # Funções auxiliares (validação de CEP)
 ┃ ┗ 📄 ...
 ┣ 📂 Tests
 ┃ ┣ 📄 CepTests.dpr
 ┃ ┣ 📄 uCepHelperTests.pas
 ┃ ┣ 📄 uViaCepParserTests.pas
 ┃ ┣ 📄 uAddressTests.pas 
 ┃ ┗ 📄 uViaCepServiceTests.pas
 ┗ 📄 README.md
```

---

## 📐 Padrões aplicados

- **Repository Pattern** → encapsula acesso ao banco (`uAddressRepository`)  
- **Service Layer** → abstrai consumo da API ViaCEP (`uViaCepService`)  
- **Interface Segregation** → `uIViaCepService` define contrato para serviços externos  
- **Helper Pattern** → `uCepHelper` centraliza validação e formatação de CEP  
- **Separation of Concerns** → UI, Lógica de Negócio e Persistência bem definidos  

---

## 🛠️ Tecnologias e Dependências

- **Delphi (RAD Studio)**  
- **FireDAC** (acesso ao SQLite)  
- **SQLite** (armazenamento local)  
- **System.JSON** (parse JSON)  
- **XMLDoc / XMLIntf** (parse XML)  
- **DUnit** (testes unitários)

---

## ▶️ Execução do Projeto

1. Abra o projeto `ConsultaCEP.dproj` no **Delphi**  
2. Configure o componente `TFDConnection`:
   - Driver: `SQLite`
   - Database: `consulta.db` (será criado automaticamente se não existir)
3. Compile e execute o projeto (`F9`)  
4. Informe um CEP ou Endereço Completo e clique em **Consultar**  

---

## 🧪 Executando Testes Unitários

1. Abra o projeto `CepTests.dpr` na pasta `Tests`  
2. Compile e rode (`F9`)  
3. O **GUITestRunner** será aberto exibindo todas as suites de teste:  
   - `TCepHelperTests`  
   - `TViaCepParserTests`  
   - `TAddressTests`  
   - `TAddressRepositoryTests`  
   - `TViaCepServiceTests`  
4. Clique em **Run** para validar todos os testes  

---

## 📋 Boas práticas seguidas

- Uso de **interfaces** para facilitar manutenção e testes  
- **Tratamento de erros** e mensagens claras para o usuário  
- **Testes unitários** garantindo estabilidade  
- **Banco local** para performance e redução de chamadas à API  
- Código comentado e estruturado para fácil evolução  

---

👨‍💻 Desenvolvido como parte de desafio técnico em Delphi.
