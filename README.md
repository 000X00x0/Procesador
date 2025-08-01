
# 🧠 Procesador RISC-V Monociclo

Un procesador RISC-V de ciclo único implementado en Verilog. Ejecuta todas las fases de instrucción (fetch, decode, execute, memory access, writeback) en un solo ciclo de reloj.

---

## 🏗️ Arquitectura del Sistema

El procesador se implementa como un módulo top-level llamado `monociclo`, que integra ocho unidades funcionales principales:

### 🔧 Componentes Principales

- **Program Counter (`program_counter`)**: Dirección actual de la instrucción.
- **Instruction Memory (`instruction_memory`)**: Memoria para fetch de instrucciones.
- **Control Unit (`control_unit`)**: Decodifica instrucciones y genera señales de control.
- **Register File (`register_unit`)**: 32 registros de 32 bits con dos puertos de lectura.
- **ALU (`alu`)**: Realiza operaciones aritméticas y lógicas.
- **Branch Unit (`branch_unit`)**: Evalúa condiciones de salto.
- **Data Memory (`data_memory`)**: Memoria de datos con soporte para acceso a distintos tamaños.
- **Immediate Generator (`immediate_generator`)**: Genera valores inmediatos según el tipo de instrucción.

---

## 🔌 Interfaz del Módulo Principal

```verilog
module monociclo (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] pc,
    output wire [31:0] instruction,
    output wire [31:0] result
);
```

---

## 🧭 Unidad de Control

Decodifica las instrucciones RISC-V y genera 9 señales de control. Soporta los siguientes tipos:

| Opcode   | Tipo    | Descripción                     |
|----------|---------|---------------------------------|
| 0110011  | R-type  | Operaciones registro a registro |
| 0010011  | I-type  | Aritmética con inmediatos       |
| 0000011  | Load    | Carga desde memoria             |
| 0100011  | Store   | Escritura a memoria             |
| 1100011  | Branch  | Saltos condicionales            |
| 1101111  | JAL     | Jump and Link                   |

---

## 🧠 Memoria de Datos

`data_memory` implementa una memoria de 1024 bytes que soporta:

- `LB`, `LBU`: Carga de byte (con o sin signo)
- `LH`, `LHU`: Carga de half-word
- `LW`: Carga de word completa
- `SB`, `SH`, `SW`: Escritura de byte, half-word y word

---

## 🔄 Flujo de Datos

### Selección de Operandos ALU

```verilog
assign operand2 = (alu_src_sel == 2'b00) ? rs2_data : imm;
assign alu_op1  = rs1_data;
```

### Selección de datos para escribir en registro

```verilog
assign datos_alRegistro = (reg_src == 2'b00) ? result     :
                          (reg_src == 2'b01) ? mem_out    :
                          (reg_src == 2'b10) ? (pc + 4)   :
                                               32'b0;
```

---

## 🧪 Entorno de Verificación

El testbench `monociclo_tb` permite monitorear todas las señales internas para debug:

```verilog
$display("%5t | %h | %h | %h | %h | %h | %h | %h | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
    $time, pc, instruction, rs1_data, rs2_data, alu_op1, operand2,
    result, zero, reg_write, mem_write, mem_ctrl,
    alu_src_sel, alu_control, reg_src, branch_ctrl, br_op);
```

---

## ⚙️ Características del Diseño

- ✅ Memorias de instrucciones y datos separadas
- ✅ Señales internas expuestas para facilitar la verificación
- ✅ Compatible con los tipos de instrucciones básicos de RISC-V

---

## ▶️ Compilación y Simulación

1. Compila todos los módulos Verilog
2. Ejecuta el testbench `monociclo_tb`
3. Observa la salida con las señales internas

---


Repositorio creado para prácticas de arquitectura de computadores y simulación digital en FPGA/ModelSim.

