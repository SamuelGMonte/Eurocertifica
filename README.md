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
