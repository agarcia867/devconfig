# Architecture Documentation Generation

## Overview

This guide provides AI agents with comprehensive instructions for generating
high-quality software architecture documentation using a structured template
approach. The template consists of 12 sections that provide a complete view of
system architecture.

## Documentation Structure

The architecture documentation template consists of 12 sections that provide a
complete view of system architecture:

1. **Introduction and Goals**
2. **Architecture Constraints**
3. **Context and Scope**
4. **Solution Strategy**
5. **Building Block View**
6. **Runtime View**
7. **Deployment View**
8. **Cross-cutting Concepts**
9. **Architecture Decisions**
10. **Quality Requirements**
11. **Technical Risks**
12. **Glossary**

## Core Principles for AI Agents

### 1. Understand Before Documenting

- **Analyze the codebase thoroughly** before generating documentation
- **Identify existing patterns** and architectural decisions
- **Study dependencies** and data flow between components
- **Map stakeholder concerns** to appropriate documentation sections

### 2. Follow Structured Approach

- **Maintain section order** and numbering as defined in the template
- **Use consistent formatting** across all sections
- **Include clear section headings** and subheadings
- **Reference diagrams and images** appropriately

### 3. Content Quality Standards

- **Be specific and concrete** - avoid vague generalizations
- **Include measurable criteria** for quality requirements
- **Document actual decisions made** rather than generic options
- **Provide clear rationale** for architectural choices

## Section-by-Section Generation Guide

### Section 1: Introduction and Goals

**Purpose**: Establish the context and driving forces for the architecture.

**Key Elements to Extract/Generate**:

- Business objectives and constraints
- Primary stakeholders and their concerns
- Functional requirements overview
- Quality goals (performance, security, maintainability, etc.)
- Success criteria

**AI Agent Tasks**:

- Analyze business logic and domain models
- Identify primary use cases from code structure
- Extract quality attributes from configuration and implementation patterns
- Map stakeholder roles from access patterns and API designs

**Subsection Structure**:

- Requirements Overview
- Quality Goals
- Stakeholders

### Section 2: Architecture Constraints

**Purpose**: Document technical, organizational, and legal constraints that
limit design choices.

**Key Elements to Extract/Generate**:

- Technology stack limitations
- Organizational constraints (team structure, skills)
- Time and budget constraints
- Legal and compliance requirements
- Hardware and infrastructure limitations

**AI Agent Tasks**:

- Analyze package.json, pom.xml, or similar dependency files
- Examine deployment configurations
- Identify framework and library constraints
- Document version constraints and compatibility requirements

### Section 3: Context and Scope

**Purpose**: Define the system boundaries and external interfaces.

**Key Elements to Extract/Generate**:

- System boundary definition
- External systems and interfaces
- Data flows across boundaries
- User groups and their interactions

**AI Agent Tasks**:

- Map external API calls and integrations
- Identify database connections and external services
- Analyze authentication and authorization patterns
- Document data exchange formats and protocols

**Subsection Structure**:

- Business Context
- Technical Context

### Section 4: Solution Strategy

**Purpose**: Summarize fundamental decisions and solution approaches.

**Key Elements to Extract/Generate**:

- Overall system decomposition approach
- Technology decisions and rationale
- Top-level patterns used (layered, microservices, etc.)
- Key abstractions and concepts

**AI Agent Tasks**:

- Identify architectural patterns from code organization
- Analyze module dependencies and layering
- Extract design patterns from implementation
- Document technology stack decisions

### Section 5: Building Block View

**Purpose**: Show the static decomposition of the system.

**Key Elements to Extract/Generate**:

- System decomposition at multiple levels
- Component responsibilities and interfaces
- Internal structure of key components
- Dependencies between building blocks

**AI Agent Tasks**:

- Analyze package/module structure
- Map class hierarchies and relationships
- Identify key interfaces and contracts
- Generate component diagrams from code structure

**Subsection Structure**:

- Overall System View
- Level 2 Components
- Level 3 Details

### Section 6: Runtime View

**Purpose**: Describe behavior and interactions at runtime.

**Key Elements to Extract/Generate**:

- Important scenarios and use cases
- Runtime interactions between components
- Data flow during key operations
- Error handling and exception flows

**AI Agent Tasks**:

- Trace execution paths through key use cases
- Analyze API endpoints and their interactions
- Map data transformation points
- Document asynchronous operations and event flows

### Section 7: Deployment View

**Purpose**: Describe the technical infrastructure and deployment.

**Key Elements to Extract/Generate**:

- Infrastructure overview
- Deployment artifacts and their mapping
- Runtime environment configuration
- Network communication paths

**AI Agent Tasks**:

- Analyze Docker files, deployment scripts
- Extract configuration management approaches
- Map environment-specific settings
- Document scaling and load balancing strategies

### Section 8: Cross-cutting Concepts

**Purpose**: Document concepts that affect multiple parts of the system.

**Key Elements to Extract/Generate**:

- Security concepts and implementation
- Safety and reliability measures
- Performance and scalability approaches
- Logging, monitoring, and diagnostics
- Error handling strategies
- Data management and persistence

**AI Agent Tasks**:

- Identify security patterns and implementations
- Analyze logging and monitoring configurations
- Extract error handling patterns
- Document data validation and persistence strategies

### Section 9: Architecture Decisions

**Purpose**: Record important architectural decisions and their rationale.

**Key Elements to Extract/Generate**:

- Technology choice decisions
- Pattern selection rationale
- Trade-off analyses
- Decision drivers and consequences

**AI Agent Tasks**:

- Identify decision points from code comments and documentation
- Analyze alternative implementations that were considered
- Extract rationale from commit messages and code reviews
- Document trade-offs made

**Subsection Structure**:

- ADR-001: [Decision Title]
    - Status
    - Context
    - Decision
    - Consequences

### Section 10: Quality Requirements

**Purpose**: Define specific, measurable quality requirements.

**Key Elements to Extract/Generate**:

- Performance requirements and current metrics
- Security requirements and implementation
- Usability and accessibility requirements
- Maintainability and testability measures
- Reliability and availability targets

**AI Agent Tasks**:

- Analyze performance testing code and benchmarks
- Extract security controls and validations
- Identify monitoring and alerting thresholds
- Document testing strategies and coverage

**Subsection Structure**:

- Performance Requirements
- Safety Requirements
- Security Requirements

### Section 11: Technical Risks

**Purpose**: Identify and assess technical risks and risk mitigation strategies.

**Key Elements to Extract/Generate**:

- Technology risks and dependencies
- Performance and scalability risks
- Security vulnerabilities
- Integration and interface risks
- Mitigation strategies and contingency plans

**AI Agent Tasks**:

- Analyze dependency vulnerabilities
- Identify single points of failure
- Assess technology obsolescence risks
- Document monitoring and alerting for risk indicators

### Section 12: Glossary

**Purpose**: Define important terms and concepts.

**Key Elements to Extract/Generate**:

- Domain-specific terminology
- Technical concepts and abbreviations
- Business terms and definitions
- Acronyms and their meanings

**AI Agent Tasks**:

- Extract domain model classes and their purposes
- Identify business terminology from code and comments
- Compile technical acronyms and abbreviations
- Create definitions from code documentation

## Documentation Generation Workflow

### Phase 1: Discovery and Analysis

1. **Scan codebase structure** - identify main directories, modules, and
   dependencies
2. **Analyze configuration files** - extract technology stack, environment
   settings
3. **Map external dependencies** - APIs, databases, third-party services
4. **Identify architectural patterns** - from code organization and
   implementation

### Phase 2: Content Generation

1. **Start with high-level sections** (1-4) to establish context
2. **Generate structural views** (5-7) based on code analysis
3. **Extract cross-cutting concerns** (8) from patterns across the codebase
4. **Document decisions and quality aspects** (9-11) from implementation choices
5. **Compile glossary** (12) from domain and technical terminology

### Phase 3: Validation and Refinement

1. **Cross-reference consistency** across all sections
2. **Validate technical accuracy** against actual implementation
3. **Ensure stakeholder alignment** with documented goals and constraints
4. **Check completeness** of all required sections

## Best Practices for AI Agents

### Code Analysis Techniques

- **Static analysis**: Parse imports, dependencies, class hierarchies
- **Dynamic analysis**: Trace execution paths and data flows
- **Configuration analysis**: Extract deployment and runtime settings
- **Documentation mining**: Leverage existing comments and documentation

### Content Quality Guidelines

- **Use specific examples** rather than generic descriptions
- **Include actual metrics** and measurements where available
- **Reference real components** and their relationships
- **Provide actionable information** for stakeholders

### Diagram Generation

- **Generate standard diagram formats** (PlantUML, Mermaid, or
  framework-specific formats)
- **Include multiple view levels** (system, container, component)
- **Show actual relationships** found in the code
- **Use consistent notation** throughout all diagrams

### Maintenance Considerations

- **Include version information** and last update timestamps
- **Link to source code** references where appropriate
- **Mark generated content** vs. manually curated content
- **Provide regeneration instructions** and automation hooks

## Output Format Guidelines

### File Structure

```
documentation/
├── sections/
│   ├── 01_introduction_and_goals
│   ├── 02_architecture_constraints
│   ├── ...
│   └── 12_glossary
├── images/
│   ├── diagrams/
│   └── screenshots/
└── architecture_documentation
```

### Formatting Standards

- Use appropriate heading levels (H1, H2, H3, H4)
- Include image references with alt text
- Use code blocks with language specification
- Apply consistent table formatting
- Include cross-references between sections

### Framework-Agnostic Content

Documentation should be structured to work with any documentation framework:

- Markdown for general compatibility
- reStructuredText for Sphinx
- AsciiDoc for advanced features
- HTML for web publishing

## Integration with Development Workflow

### Automated Generation

- **Trigger on significant commits** to maintain up-to-date documentation
- **Integrate with CI/CD** pipelines for automatic updates
- **Version control documentation** alongside code changes
- **Generate delta reports** highlighting changes since last update

### Human Review Process

- **Flag sections requiring manual review** (business context, stakeholder
  goals)
- **Highlight assumptions** made during generation
- **Provide confidence levels** for generated content
- **Enable easy editing** of generated documentation

### Tool Integration

- **Export to common formats** (HTML, PDF, Word) for distribution
- **Integrate with diagramming tools** (draw.io, PlantUML, Mermaid)
- **Connect to project management** systems for stakeholder information
- **Link to monitoring** and metrics systems for real-time quality data

## Common Pitfalls to Avoid

1. **Generic Content**: Avoid template language; be specific to the actual
   system
2. **Inconsistent Abstraction Levels**: Maintain appropriate detail level for
   each section
3. **Missing Stakeholder Context**: Don't just document structure; explain
   purpose and decisions
4. **Outdated Information**: Ensure generated content reflects current
   implementation
5. **Poor Cross-References**: Maintain consistency across related sections
6. **Missing Trade-offs**: Document why alternatives were rejected
7. **Vague Quality Requirements**: Use measurable, testable criteria
8. **Incomplete Risk Analysis**: Consider both technical and business risks

## Success Metrics

- **Completeness**: All 12 sections contain relevant, non-generic content
- **Accuracy**: Generated documentation matches actual implementation
- **Usability**: Stakeholders can find answers to their specific questions
- **Maintainability**: Documentation can be easily updated as system evolves
- **Actionability**: Decisions and requirements are specific enough to guide
  development

This guide should be used by AI agents as a comprehensive reference for
generating high-quality, structured architecture documentation that serves the
actual needs of software development teams and stakeholders, regardless of the
documentation framework used.
