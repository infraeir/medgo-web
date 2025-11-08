# Modal de Prescrição - Documentação Completa

Este documento detalha o funcionamento completo do modal de prescrição médica, seus diferentes tipos e comportamentos específicos.

## 📋 Visão Geral

O modal de prescrição é um componente complexo que se adapta a diferentes contextos médicos, desde prescrições sem paciente até consultas com pacientes específicos. O sistema utiliza componentes modulares para maximum flexibilidade e reutilização.

## 🏗️ Arquitetura Componentizada

```
lib/pages/prescription/
├── enums/
│   └── prescription_type.dart          # Enum com os 5 tipos de prescrição
├── widgets/
│   ├── prescription_header.dart        # Cabeçalho adaptável
│   ├── prescription_footer.dart        # Rodapé com ações
│   └── prescription_list.dart          # Lista de medicações/vacinas
├── prescription.dart                   # Modal principal
└── README.md                          # Esta documentação
```

## 🔧 Tipos de Prescrição

### 1. `withoutPatient` - Prescrição Livre
**Cenário**: Prescrição genérica sem paciente específico

**Características**:
- ✅ Ícone de selecionar paciente à esquerda do título "Prescrição"
- ✅ **Não é obrigatório** selecionar paciente para prescrever
- ✅ Permite selecionar medicamentos livremente no dropdown
- ❌ **Não há indicações** médicas automáticas
- ✅ Pode **TROCAR** e **EDITAR** paciente a qualquer momento
- 📄 **Impressão**: Não exibe nome do paciente nem informações que não existem

**Interface**:
- Header: Botão de seleção de paciente + título + fechar
- Conteúdo: Select de medicamentos + lista de prescrições
- Footer: Ações completas (datas, visualizar, copiar, imprimir, salvar)

### 2. `withPatientDuringCalculator` - Prescrição por Calculadora
**Cenário**: Prescrições geradas automaticamente por calculadoras médicas

**Características**:
- ❌ **Não há paciente** selecionado nem opção para selecionar
- ✅ **Apenas indicações** automáticas da calculadora
- ❌ **Não há modal** de seleção de medicamentos
- ❌ **Não pode TROCAR nem EDITAR** paciente (não existe)
- 📄 **Impressão**: Não exibe informações de paciente

**Interface**:
- Header: Apenas título + fechar
- Conteúdo: Apenas lista de indicações automáticas
- Footer: Ações de impressão

### 3. `withPatientDuringConsultation` - Consulta Ativa
**Cenário**: Prescrição durante uma consulta médica em andamento

**Características**:
- ✅ **Paciente já selecionado** e vinculado à consulta
- ✅ **Lista de indicações** baseada no diagnóstico
- ✅ Select de medicamentos disponível
- ✅ Pode **EDITAR** informações do paciente
- ❌ **Não pode TROCAR** paciente (vinculado à consulta)
- 📄 **Impressão**: Exibe nome completo e informações do paciente

**Interface**:
- Header: Informações do paciente + botão editar + título + fechar
- Conteúdo: Select de medicamentos + indicações + lista de prescrições
- Footer: Ações completas com validação de dados do paciente

### 4. `withoutPatientNeedSelection` - Seleção Obrigatória
**Cenário**: Prescrição onde é obrigatório selecionar um paciente primeiro

**Características**:
- ⚠️ **Obrigatoriamente** deve selecionar paciente primeiro
- 🚫 Select de medicamentos **só aparece após** seleção do paciente
- 🔍 **Deve ser criado** um select de pacientes (comportamento igual ao de medicamentos)
- ❌ **Não há indicações** automáticas
- ✅ Pode **TROCAR** e **EDITAR** paciente após seleção
- 📄 **Impressão**: Exibe informações do paciente selecionado

**Interface**:
- Header: Botão "Selecionar paciente" + título + fechar
- Conteúdo: Select de pacientes (obrigatório) → depois Select de medicamentos
- Footer: Ações habilitadas apenas após seleção do paciente

### 5. `withPatientOutsideConsultation` - Paciente Pré-selecionado
**Cenário**: Prescrição para paciente específico fora de consulta

**Características**:
- ✅ **Paciente já selecionado** ao abrir o modal
- ❌ **Não há indicações** automáticas
- ✅ Select de medicamentos disponível imediatamente
- ✅ Pode **EDITAR** informações do paciente
- ❌ **Não pode TROCAR** paciente (contexto específico)
- 📄 **Impressão**: Exibe nome e informações do paciente

**Interface**:
- Header: Informações do paciente + botão editar + título + fechar
- Conteúdo: Select de medicamentos + lista de prescrições
- Footer: Ações completas com dados do paciente

## 🧩 Componentes Principais

### PrescriptionHeader
Adapta-se automaticamente ao tipo de prescrição:

```dart
PrescriptionHeader(
  prescriptionType: PrescriptionType.withPatientDuringConsultation,
  patient: patientModel,
  onClose: () => Navigator.pop(context),
  onChangePatient: _handleChangePatient,    // Condicional
  onEditPatient: _handleEditPatient,        // Condicional
  onSelectPatient: _handleSelectPatient,    // Condicional
)
```

**Comportamentos por tipo**:
- `withoutPatient`: Mostra botão de seleção opcional
- `withPatientDuringCalculator`: Apenas título e fechar
- `withPatientDuringConsultation`: Informações + editar (sem trocar)
- `withoutPatientNeedSelection`: Botão de seleção obrigatória
- `withPatientOutsideConsultation`: Informações + editar (sem trocar)

### PrescriptionFooter
Rodapé com todas as ações disponíveis:

```dart
PrescriptionFooter(
  onEmissionDateChanged: (date) => _updateEmissionDate(date),
  onExpirationDateChanged: (date) => _updateExpirationDate(date),
  onPreviewPrint: () => _showPrintPreview(),
  onNavigateBack: () => _navigateBack(),
  onDeletePrescription: () => _deletePrescription(),
  onCopyPrescription: () => _copyToClipboard(),
  onPrintPrescription: () => _generatePDF(),
  onSavePrescription: () => _savePrescription(),
)
```

**Funcionalidades**:
- **Datas**: Emissão e validade da receita
- **Visualização**: Preview antes da impressão
- **Ações**: Copiar, imprimir, salvar, excluir
- **Navegação**: Voltar, cancelar

## 📝 Fluxos de Uso

### Fluxo 1: Prescrição Livre (`withoutPatient`)
1. Modal abre sem paciente
2. Usuário pode começar a prescrever imediatamente
3. Opcionalmente seleciona paciente pelo botão no header
4. Adiciona medicamentos via select
5. Finaliza com impressão/salvamento

### Fluxo 2: Calculadora (`withPatientDuringCalculator`)
1. Modal abre com indicações pré-carregadas
2. Usuário revisa as indicações automáticas
3. Finaliza com impressão/salvamento
4. Não há interação com pacientes

### Fluxo 3: Consulta Ativa (`withPatientDuringConsultation`)
1. Modal abre com paciente da consulta
2. Mostra indicações baseadas no diagnóstico
3. Usuário pode adicionar medicamentos extras
4. Pode editar dados do paciente se necessário
5. Finaliza prescrição completa

### Fluxo 4: Seleção Obrigatória (`withoutPatientNeedSelection`)
1. Modal abre com select de pacientes
2. **Obrigatório** selecionar paciente primeiro
3. Após seleção, libera select de medicamentos
4. Processo normal de prescrição
5. Finaliza com dados completos do paciente

### Fluxo 5: Paciente Específico (`withPatientOutsideConsultation`)
1. Modal abre com paciente pré-selecionado
2. Select de medicamentos disponível imediatamente
3. Processo normal de prescrição
4. Pode editar dados do paciente
5. Finaliza com impressão incluindo dados do paciente

## 🎨 Estados da Interface

### Estados do Header
- **Sem paciente**: Botão de seleção + título
- **Com paciente**: Foto/ícone + informações + ações + título
- **Seleção obrigatória**: Mensagem + botão de seleção + título
- **Apenas título**: Calculadora sem pacientes

### Estados do Conteúdo
- **Select visível**: Quando pode adicionar medicamentos
- **Select bloqueado**: Até selecionar paciente (tipo 4)
- **Apenas indicações**: Calculadora (tipo 2)
- **Lista vazia**: Estado inicial sem medicamentos
- **Lista preenchida**: Com medicamentos/indicações selecionadas

### Estados do Footer
- **Ações limitadas**: Sem paciente ou dados incompletos
- **Ações completas**: Com todos os dados necessários
- **Datas obrigatórias**: Para impressão e salvamento
- **Validações**: Campos obrigatórios por tipo de prescrição

## 🔄 Integrações

### Com Página de Pacientes
```dart
// Prescrição para paciente específico
NewPrescriptionModal(
  prescriptionType: PrescriptionType.withPatientOutsideConsultation,
  patient: selectedPatient,
  doctor: currentDoctor,
  peso: patient.weight ?? '70',
)
```

### Com Consultas
```dart
// Durante consulta ativa
NewPrescriptionModal(
  prescriptionType: PrescriptionType.withPatientDuringConsultation,
  patient: consultation.patient,
  doctor: consultation.doctor,
  consultationId: consultation.id,
  peso: consultation.patient.weight,
)
```

### Com Calculadoras
```dart
// Resultado de calculadora médica
NewPrescriptionModal(
  prescriptionType: PrescriptionType.withPatientDuringCalculator,
  doctor: currentDoctor,
  calculatorId: calculator.id,
  peso: calculatorResult.weight,
)
```

## ✅ Validações e Regras

### Por Tipo de Prescrição
- **Tipo 1**: Paciente opcional, medicamentos livres
- **Tipo 2**: Sem paciente, apenas indicações automáticas
- **Tipo 3**: Paciente obrigatório (da consulta), não pode trocar
- **Tipo 4**: Paciente obrigatório (seleção), pode trocar
- **Tipo 5**: Paciente obrigatório (pré-selecionado), pode editar

### Para Impressão
- **Com paciente**: Nome, idade, peso, etnia obrigatórios
- **Sem paciente**: Apenas medicamentos e dados do médico
- **Datas**: Emissão e validade sempre obrigatórias
- **Médico**: CRM e nome sempre obrigatórios

### Para Salvamento
- **Dados mínimos**: Pelo menos um medicamento selecionado
- **Dados completos**: Depende do tipo de prescrição
- **Validação de campos**: Conforme regras de cada tipo

## 🚀 Próximas Melhorias

1. ✅ **Select de Pacientes**: Implementado `SelectPatientMedGo` para tipo `withoutPatientNeedSelection`
2. **Validações Avançadas**: Interações medicamentosas
3. **Templates**: Prescrições modelo por especialidade
4. **Histórico**: Prescrições anteriores do paciente
5. **Assinatura Digital**: Integração com certificado médico
6. **Impressão Customizada**: Templates por clínica/médico

## 📞 Suporte

Para dúvidas sobre implementação ou uso do modal de prescrição:
- Consulte os exemplos nos arquivos de teste
- Verifique os callbacks implementados
- Analise os tipos de prescrição no enum
- Teste os diferentes fluxos de uso
