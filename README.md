# Eurocertifica

A plataforma tem como objetivo gamificar a gestão de desempenho e aprendizado de colaboradores, permitindo que gestores acompanhem times, atribuam desafios e recompensas, e que colaboradores acompanhem seu progresso, participem de trilhas e troquem pontos por benefícios.

## Estrutura

- `lib/core`: tema e elementos transversais.
- `lib/features/learning/domain`: entidades, contratos e casos de uso.
- `lib/features/learning/data`: seed de cursos, modelos JSON e persistência local.
- `lib/features/learning/presentation`: controlador, telas e widgets.

## Rodar

```bash
flutter pub get
flutter run -d chrome
```

## Validar

```bash
flutter analyze
flutter test
```

## 📚 Documentação de API

A documentação da API está em `doc/swagger/api-docs.yaml` no formato OpenAPI 3.0.

Para visualizar interativamente:
- **Swagger UI:** [https://editor.swagger.io](https://editor.swagger.io) (cole o conteúdo do arquivo)

## Documentação de Arquitetura (C4)

Este documento descreve a arquitetura da solução utilizando o modelo **C4 (Contexto, Contêineres e Componentes)**.

Os diagramas são renderizados utilizando a sintaxe **Mermaid**. Você pode visualizá-los em qualquer ferramenta compatível (GitHub, GitLab, Obsidian, ou o [Mermaid Live Editor](https://mermaid.live/)).

---

### 📍 Nível 1: Diagrama de Contexto (C1)

```mermaid
C4Context
    title Diagrama de Contexto - Plataforma de Gamificação de Desempenho

    Person(colaborador, "Colaborador", "Acessa dashboards, trilhas, desafios e chat")
    Person(gestor, "Gestor", "Define desafios, acompanha times e interage")
    System(plataforma, "Plataforma Challenge", "Gerencia pontos, rankings, certificados e comunicação")
    System(db, "Banco de Dados Corporativo", "Dados de colaboradores, gestores e cursos")

    Rel(colaborador, plataforma, "Usa")
    Rel(gestor, plataforma, "Gerencia")
    Rel(plataforma, db, "Consulta e integra")
```

### 📍 Nível 2: Diagrama de Contêineres (C2)

```mermaid
C4Container
    title Diagrama de Contêineres - Plataforma Challenge

    Person(colaborador, "Colaborador")
    Person(gestor, "Gestor")

    System_Boundary(challenge, "Plataforma Challenge") {
        Container(web_app, "Aplicação Web", "React/Frontend", "Dashboards, telas de cadastro, chat e ranking")
        Container(api, "API Backend", "Node.js/Java", "Regras de negócio, pontos, desafios e certificados")
        Container(db_app, "Banco de Dados App", "PostgreSQL", "Armazena mensagens, recompensas, desafios personalizados")
        Container(integracao, "Integrador Corporativo", "ETL/API", "Conecta com sistemas internos de RH e cursos")
    }

    System_Ext(db_corp, "Banco Corporativo", "Dados de colaboradores e gestores")

    Rel(colaborador, web_app, "Acessa", "HTTPS")
    Rel(gestor, web_app, "Gerencia", "HTTPS")
    Rel(web_app, api, "Consome", "JSON/REST")
    Rel(api, db_app, "Persiste", "SQL")
    Rel(api, integracao, "Usa")
    Rel(integracao, db_corp, "Consulta")
```

### 📍 Nível 3: Diagrama de Componentes (C3) – Backend Principal

```mermaid
C4Component
    title Diagrama de Componentes - API Backend

    Container_Boundary(api, "API Backend") {
        Component(autenticacao, "Autenticação", "JWT/OAuth", "Gerencia login e acesso")
        Component(dashboard_colab, "Dashboard Colaborador", "Backend", "Progresso pessoal e pontos")
        Component(dashboard_gestor, "Dashboard Gestor", "Backend", "Visão do time e desafios")
        Component(pontos, "Sistema de Pontos", "Regras de negócio", "Atribui e acumula 'moscas'")
        Component(desafios, "Gestão de Desafios", "CRUD", "Cadastro e atribuição por área/competência")
        Component(chat, "Chat Gestor-Colaborador", "WebSocket/REST", "Mensagens diretas")
        Component(ranking, "Ranking", "Algoritmo", "Classifica desempenho")
        Component(certificados, "Certificados", "Gerador PDF", "Emissão automática")
        Component(recompensas, "Catálogo de Recompensas", "Transação", "Troca de pontos por benefícios")
    }

    System(db_app, "Banco de Dados App")
    System(db_corp, "Banco Corporativo")

    Rel(autenticacao, db_app, "Valida usuários")
    Rel(dashboard_colab, db_app, "Consulta progresso")
    Rel(dashboard_gestor, db_app, "Consulta times")
    Rel(pontos, db_app, "Registra pontos")
    Rel(desafios, db_app, "CRUD desafios")
    Rel(chat, db_app, "Armazena mensagens")
    Rel(ranking, db_app, "Lê pontuações")
    Rel(certificados, db_app, "Valida trilhas")
    Rel(recompensas, db_app, "Gerencia trocas")

    Rel(dashboard_colab, db_corp, "Busca dados do colaborador")
    Rel(dashboard_gestor, db_corp, "Busca times")
    Rel(desafios, db_corp, "Valida áreas/competências")
```
## Casos de Uso Principais

### 🧑‍💼 Onboarding
Novo colaborador completa a trilha inicial de integração e ganha sua primeira badge de "Iniciante".

---

### 🧪 Treinamento de SOP
Colaborador realiza desafio interativo sobre novo procedimento operacional padrão (SOP) da ANVISA.

---

### 📢 Intervenção do Gestor
Gestor identifica colaborador inativo há 7 dias e envia uma missão motivacional personalizada.

---

### 🏆 Resgate de Prêmio
Colaborador troca "moscas" acumuladas por uma caneca personalizada ou vale-presente no catálogo.

## 🧪 Testes

### 📋 Estrutura de Testes

Os testes estão organizados seguindo a estrutura de features:

```
test/
├── widget_test.dart
└── features/
    └── auth/
        ├── domain/
        │   ├── entities/
        │   │   └── user_entity_test.dart
        │   └── usecases/
        │       └── login_usecase_test.dart
        ├── data/
        │   ├── models/
        │   │   └── user_model_test.dart
        │   ├── repositories/
        │   │   └── auth_repository_impl_test.dart
        │   └── datasources/
        │       └── auth_remote_datasource_test.dart
        └── integration/
            ├── auth_integration_test.dart
            └── integration_end_to_end_test.dart
```

### 🚀 Executar Testes

#### 1️⃣ **Todos os testes**
```bash
flutter test
```

#### 2️⃣ **Apenas testes de uma feature**
```bash
flutter test test/features/auth/
```

#### 3️⃣ **Apenas testes de um tipo específico**

**Testes unitários:**
```bash
flutter test test/features/auth/domain/ test/features/auth/data/
```

**Testes de integração:**
```bash
flutter test test/features/auth/integration/
```

#### 4️⃣ **Um arquivo de teste específico**
```bash
flutter test test/features/auth/domain/usecases/login_usecase_test.dart
```

#### 5️⃣ **Com modo verbose (detalhado)**
```bash
flutter test -v
```

#### 6️⃣ **Com cobertura de código**
```bash
flutter test --coverage
```

Para analisar a cobertura após executar:
```bash
# Windows
lcov --list coverage/lcov.info

# macOS/Linux
lcov -l coverage/lcov.info
```

#### 7️⃣ **Com cobertura de uma feature específica**
```bash
flutter test test/features/auth/ --coverage
```

#### 8️⃣ **Parar na primeira falha**
```bash
flutter test --fail-fast
```

#### 9️⃣ **Executar apenas testes que contêm uma palavra-chave**
```bash
flutter test -k "login"
```

#### 🔟 **Gerar mocks (se necessário)**
```bash
flutter pub run build_runner build
```

### 📊 Resumo de Testes Disponíveis

| Camada | Arquivo | Tipo | Testes |
|--------|---------|------|--------|
| Domain | `login_usecase_test.dart` | Unitário | 1 |
| Data | `user_model_test.dart` | Unitário | 3 |
| Data | `auth_repository_impl_test.dart` | Unitário | 1 |
| Data | `auth_remote_datasource_test.dart` | Unitário | 2 |
| Integration | `auth_integration_test.dart` | Integração | 2 |
| Integration | `integration_end_to_end_test.dart` | Integração | 1 |
| **Total** | - | - | **11** |

### 🎯 Verificações Implementadas

- ✅ Factories de entidades
- ✅ Igualdade de objetos
- ✅ Serialização/Desserialização
- ✅ Mocking de dependências
- ✅ Testes de exceção
- ✅ Testes de rede
- ✅ Validações de entrada
- ✅ Fluxo completo end-to-end

### 📦 Dependências de Teste

```yaml
dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

### 💡 Dicas Úteis

- **Rodar testes em modo watch:** Use uma extensão de IDE ou execute múltiplas vezes
- **Melhorar performance:** Execute testes de uma feature por vez
- **CI/CD:** Configure pipelines para rodar `flutter test --coverage` automaticamente
- **Cobertura ideal:** Mantenha acima de 85% no total do projeto
