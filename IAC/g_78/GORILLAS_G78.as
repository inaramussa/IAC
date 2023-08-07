;===============================================================================;
; Programa GORILLAS_G78.as                                                          ;
;                                                                               ;
; Descricao: Jogo GORILLAS para um jogador                                      ;
;                                                                               ; 
; Autores: Ricardo Calvao - 92545, Inara Parbato - 91110                        ; 
; Grupo: 78                                                                     ;
;===============================================================================;

;===============================================================================;
;                             Zona das Constantes                               ;
;===============================================================================;

TIMER_COUNT     EQU     FFF6h
TIMER_CTRL      EQU     FFF7h
MASK            EQU     FFFAh
IO_READ		    EQU		FFFFh
IO_WRITE	    EQU		FFFEh
IO_CTRL		    EQU		FFFCh
                
;===============================================================================;
;                             Zona das Variaveis                                ;
;===============================================================================;

                ORIG    8000h

T               WORD    0       ; Valor T para o calculo da trajetoria do projetil
V 			    WORD	20		; Velocidade intoduzida
ANG			    WORD	45		; Angulo intoduzido
X0			    WORD	1202h	;|Posicoes dos dois gorilas
X1              WORD    1242h	;|
TAB_COS			STR		0000000001000000b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111111b, 0000000000111110b, 0000000000111110b, 0000000000111110b, 0000000000111110b, 0000000000111101b, 0000000000111101b, 0000000000111101b, 0000000000111100b, 0000000000111100b, 0000000000111100b, 0000000000111011b, 0000000000111011b, 0000000000111010b, 0000000000111010b, 0000000000111010b, 0000000000111001b, 0000000000111001b, 0000000000111000b, 0000000000110111b, 0000000000110111b, 0000000000110110b, 0000000000110110b, 0000000000110101b, 0000000000110101b, 0000000000110100b, 0000000000110011b, 0000000000110011b, 0000000000110010b, 0000000000110001b, 0000000000110001b, 0000000000110000b, 0000000000101111b, 0000000000101110b, 0000000000101110b, 0000000000101101b, 0000000000101100b, 0000000000101011b, 0000000000101010b, 0000000000101001b, 0000000000101001b, 0000000000101000b, 0000000000100111b, 0000000000100110b, 0000000000100101b, 0000000000100100b, 0000000000100011b, 0000000000100010b, 0000000000100001b, 0000000000100000b, 0000000000100000b, 0000000000011111b, 0000000000011110b, 0000000000011101b, 0000000000011100b, 0000000000011011b, 0000000000011010b, 0000000000011001b, 0000000000010111b, 0000000000010110b, 0000000000010101b, 0000000000010100b, 0000000000010011b, 0000000000010010b, 0000000000010001b, 0000000000010000b, 0000000000001111b, 0000000000001110b, 0000000000001101b, 0000000000001100b, 0000000000001011b, 0000000000001010b, 0000000000001000b, 0000000000000111b, 0000000000000110b, 0000000000000101b, 0000000000000100b, 0000000000000011b, 0000000000000010b, 0000000000000001b, 0000000000000000b

PONTOS          WORD    0

POS_ANTERIOR    WORD    5100h

SEED            WORD    0
RANDOM_X        WORD    0

INICIO_STRING   STR     '  ____   ___   ____   ____  _      _       ____  _____@ /    | /   \ |    \ |    || |    | |     /    |/ ___/@|   __||     ||  D  ) |  | | |    | |    |  o  (   \_ @|  |  ||  O  ||    /  |  | | |___ | |___ |     |\__  |@|  |_ ||     ||    \  |  | |     ||     ||  _  |/  \ |@|     ||     ||  .  \ |  | |     ||     ||  |  |\    |@|_____| \___/ |__|\_||____||_____||_____||__|__| \___|@@          Carregue no botao A para comecar', 0
GORILA_STRING	STR		'  __@ 0', 39, 39, '0@ (', 39, 39,')@/\__/\@_/__\_', 0 ; O caracter 39 representa um apostrofo
GORILA_STRING_M	STR		'  __@ 0><0@\(', 39, 39,')/@ \__/ @_/__\_', 0
PREDIO          STR     '_______________________@ |   _     _     _   |@ |  | |   | |   | |  |', 0

START           WORD    0
BOTAO           WORD    -1
ACERTOU         WORD    -1

ANG_STRING    STR     'Angulo:__', 0
V_STRING    STR     'Velocidade:__', 0
				
;===============================================================================;
;                               Inicializacoes                                  ;
;===============================================================================;

                ORIG    0000h
				
                MOV     R1, FDFFh
                MOV     SP,R1
				
                MOV		R1, FFFFh
			    MOV		M[IO_CTRL], R1
				
                MOV     R1, 0400h       ; 0000 0100 0000 0000 b
                MOV     M[MASK],R1      ; So o botao A esta ativo
				
                MOV     R1, INT_B0
                MOV     M[FE00h],R1
                MOV     R1, INT_B1
                MOV     M[FE01h],R1
                MOV     R1, INT_B2
                MOV     M[FE02h],R1
                MOV     R1, INT_B3
                MOV     M[FE03h],R1
                MOV     R1, INT_B4
                MOV     M[FE04h],R1
                MOV     R1, INT_B5
                MOV     M[FE05h],R1
                MOV     R1, INT_B6
                MOV     M[FE06h],R1
                MOV     R1, INT_B7
                MOV     M[FE07h],R1
                MOV     R1, INT_B8
                MOV     M[FE08h],R1
                MOV     R1, INT_B9
                MOV     M[FE09h],R1
				
                MOV     R1, INT_BA
                MOV     M[FE0Ah],R1
				
                MOV     R1, INT_TIMER
                MOV     M[FE0Fh],R1
				
				
                ENI     
				
                MOV     M[TIMER_COUNT],R0
                MOV     R1, 1
                MOV     M[TIMER_CTRL],R1
                
;===============================================================================;
;                             Inicio do programa                                ;
;===============================================================================;

                PUSH    INICIO_STRING   
                PUSH    070Dh
                CALL    ESCREVE_STRING    ; Desenhar a mensagem inicial
                
                MOV     R1, 1
INICIO:         INC     R1
                CMP     M[START], R0
                BR.Z    INICIO
                MOV     M[SEED], R1       ; Loop para guardar valor aleatorio
                
;===============================================================================;
;                               Funcao Principal                                ;
;===============================================================================;	
		
MAIN:           CALL    DEF_COORDS        ; Definir coordenadas aleatorias para os gorilas

OUTRA_VEZ:      CALL    DESENHA_JOGO

                CALL    LER_ANG_V
				
                MOV     R1, -1
                MOV     M[ACERTOU], R1
				
                CALL    ATIRAR
				
ESPERAR:        CMP     M[ACERTOU], R0    ; M[ACERTOU] depende se a banana acerou em algo ou se caiu
                BR.N    ESPERAR
                BR.Z    OUTRA_VEZ         ; Se nao acertou nao calcula novas coordenadas
                CALL    ACERTOU_ANIM
                BR      MAIN              ; Se acertou aumenta os pontos e recomeca o programa
                
;===============================================================================;
;                              Funcoes Auxiliares                               ;
;===============================================================================;	
      
ATIRAR:         PUSH    R1                ; Faz o gorila levantar a mao e ativa o timer
                PUSH    R2
				
                MOV     R2, M[X0]
                ADD     R2, 0205h
                MOV     R1, '/'
                MOV     M[IO_CTRL], R2
                MOV     M[IO_WRITE], R1
                ADD     R2, 0100h
                MOV     R1, ' '
                MOV     M[IO_CTRL], R2
                MOV     M[IO_WRITE], R1
                
                MOV     R1, 8000h
                OR      M[MASK], R1
                
                POP     R2
                POP     R1
                RET
                
DESENHA_GORILA: PUSH    R1                ; Desenha o gorila na coordenada especificada
                PUSH    R2
				
                PUSH	GORILA_STRING
				PUSH	M[SP + 5]
				CALL	ESCREVE_STRING
				
                POP     R1
                POP     R2
                RETN    1
                
ACERTOU_ANIM:   PUSH    R1			      ; Aumenta os pontos e faz a animacao do gorila
                PUSH    R2
				
                PUSH	GORILA_STRING_M
				PUSH	M[X1]
				CALL	ESCREVE_STRING
				
                INC     M[PONTOS]
                
                MOV     R1, 8000h
                OR      M[MASK], R1		  
				
ANIM_LOOP:      CMP     M[ACERTOU], R0    ; Esperar que o timer decremente M[ACERTOU] para que a imagem seja visivel durante um frame
                BR.NZ   ANIM_LOOP
				
                MOV     R1, EFFh
                AND     M[MASK], R1
                
                POP     R2
                POP     R1
                RET
                
DESENHA_PONTOS: PUSH    R1                ; Desenha a pontuacao no topo do ecra
                PUSH    R2
                PUSH    R3
				
                MOV     R2, 0128h
                MOV     R1, M[PONTOS]
                MOV     R3, 10
                DIV     R1, R3
                ADD     R1, '0'
                ADD     R3, '0'
                MOV     M[IO_CTRL], R2
                MOV     M[IO_WRITE], R1
                INC     R2
                MOV     M[IO_CTRL], R2
                MOV     M[IO_WRITE], R3
				
                POP     R3
                POP     R2
                POP     R1
                RET
               
BANANA:         PUSH    R1               ; Desenha a banana na posicao adequada ao T
                PUSH    R2
                PUSH    R3
                
                MOV     R2, M[POS_ANTERIOR]
                MOV		R1, ' '
			    MOV		M[IO_CTRL], R2
			    MOV		M[IO_WRITE], R1
                
                PUSH    R0
                PUSH    R0
                MOV     R1, M[T]
                PUSH    R1
			    MOV		R1, M[ANG]
			    PUSH	R1
			    MOV		R1, M[V]
			    SHL		R1, 6
                PUSH    R1
                MOV     R1, M[X0]
                AND     R1, 00FFh
                SHL     R1, 6
                PUSH    R1
                MOV     R1, M[X0]
                AND     R1, FF00h
                SHL     R1, 6
                PUSH    R1
                CALL	func_pos          ; Calcular as coordenadas
                POP     R2
                POP     R1
                
                SHL     R2, 2             ; Converter as coordenada em valores que podem ser utilizados
                AND     R2, FF00h
                NEG     R2
                ADD     R2, 1200h
                SHR     R1, 6
                ADD     R1, 5			 
                
                CMP     R2, 1800h         ; Verificar se a banana atingiu algo ou se caiu  
                BR.NP   BATEU_VERIF
                JMP     BANANA_CAIU
                
BATEU_VERIF:    CMP     R2, 1400h
                BR.NP   ACETROU_VERIF
                CMP     R1, 23
                JMP.NP  BANANA_CAIU
                CMP     R1, 38h
                JMP.NN  BANANA_CAIU
                
ACETROU_VERIF:  MOV     R3, M[X1]
                AND     R3, FF00h
                CMP     R2, R3
                BR.N    CONT_BANANA
                MOV     R3, M[X1]
                AND     R3, 00FFh
                CMP     R1, R3
                BR.N    CONT_BANANA
                ADD     R3, 4
                CMP     R1, R3
                BR.P    CONT_BANANA
                MOV     R3, 1
                JMP     BANANA_ACERTOU

CONT_BANANA:    MVBL    R2, R1            ; Se a banana nao atingiu nada ela e desenhada
                
                MOV     R1, M[T]          ; O caractere da banana alterna
                MOV     R3, 2
                DIV     R1, R3
                CMP     R3, R0
                BR.Z    FLIP              
                MOV		R1, '('
                BR      FLOP
FLIP:           MOV     R1, ')'
FLOP:	        MOV		M[IO_CTRL], R2
			    MOV		M[IO_WRITE], R1
                MOV     M[POS_ANTERIOR], R2
                BR      FIM_BANANA
                
BANANA_ACERTOU: MOV     R1, 1
                INC     M[ACERTOU]
BANANA_CAIU:    MOV     R1, 5100h           ; Reinicializar as variaveis
                MOV     M[POS_ANTERIOR], R1
                MOV     M[T], R0
                INC     M[ACERTOU]
                MOV     R1, 7FFFh
                AND     M[MASK], R1

FIM_BANANA:     POP     R3
                POP     R2
                POP     R1
                RET
              
DESENHA_JOGO:   PUSH R1						; Limpa o ecra, desenha os gorilas, os predios e os pontos
                
				MOV		R1, FFFFh
			    MOV		M[IO_CTRL], R1
                
                PUSH    PREDIO
                PUSH    1501h
                CALL    ESCREVE_STRING
                
                PUSH    PREDIO
                PUSH    1538h
                CALL    ESCREVE_STRING
                
                MOV     R1, M[X0]
                CALL    DESENHA_PONTOS
				
                PUSH    R1
                CALL    DESENHA_GORILA
				
                MOV     R1, M[X1]
                PUSH    R1
                CALL    DESENHA_GORILA
				
                POP     R1
                RET
                
RAND:           PUSH    R1                 ; Gera um numero aleatorio baseado no valor obtido no inicio do jogo e na ultima velocidade introduzida
                PUSH    R2
				
                MOV     R1, 2
                MOV     R2, M[V]
                ADD     M[SEED], R2
                ROL     M[SEED], 4
                MOV     R2, M[SEED]
                
RAND_LOOP:      MOV     R3, R2
                AND     R3, 1
                CMP     R3, R0
                BR.NZ   IMPAR
                
                MOV     R3, R2
                ROR     R3, 1
                BR      FIM_RAND
                
IMPAR:          MOV     R3, 1000001100010110b
                XOR     R3, R2
                ROR     R3, 1
                
FIM_RAND:       DEC     R1
                BR.NZ   RAND_LOOP
                MOV     M[SP + 4], R3
                POP     R2
                POP     R1
                RET
                
DEF_COORDS:     PUSH    R1                ; Gera coordenadas aleatorias entre valores especificados
                PUSH    R2
				
                PUSH    R0
                CALL    RAND
                POP     R1
                AND     R1, 00FFh
                MOV     R2, 15
                DIV     R1, R2
                ADD     R2, 1102h
                MOV     M[X0], R2
				
                PUSH    R0
                CALL    RAND
                POP     R1
                SHR     R1, 8
                MOV     R2, 15
                DIV     R1, R2
                ADD     R2, 1139h
                MOV     M[X1], R2
				
                POP     R2
                POP     R1
                RET
               
ESCREVE_STRING: PUSH    R1                ; Escreve uma cadeia de caracteres no ecra
                PUSH    R2
                PUSH    R3
                
                MOV     R1, M[SP + 6]
                MOV     R2, M[SP + 5]
                
ES_LOOP:        MOV     R3, M[R1]
                CMP     R3, R0
                BR.Z    FIM_ES
                
                CMP     R3, '@'            ; Muda de linha quando chega ao caracter '@'
                BR.NZ   CONT_ES
                INC     R1
                MVBL    R2, M[SP + 5]
                ADD     R2, 0100h
                BR      ES_LOOP
                
CONT_ES:        MOV     M[IO_CTRL], R2
                MOV     M[IO_WRITE], R3
                INC     R1
                INC     R2
                BR      ES_LOOP
                
FIM_ES:         POP     R3
                POP     R2
                POP     R1
                RETN    2
                
LER_ANG_V:      PUSH    R1                 ; Le os inputs das interrupcoes e guarda os valores do angulo e da velocidade
                PUSH    R2
                PUSH    R3
                PUSH    R4
                
                MOV     M[ANG], R0
                MOV     M[V], R0
                
                MOV     R1, 03FFh
                OR      M[MASK], R1
                
                PUSH    ANG_STRING
                PUSH    R0
                CALL    ESCREVE_STRING
                
                MOV     R2, 7              ; Posicionar o cursor para escrever
                
                MOV     R3, R0             ; Contador para limitar o numero de caracteres a 2
LOOP_ANG:       CMP     M[BOTAO], R0
                BR.N    LOOP_ANG
                
                MOV     R1, M[BOTAO]
                ADD     M[ANG], R1
                ADD     R1, '0'
                ADD     R2, R3
                MOV     M[IO_CTRL], R2
                MOV     M[IO_WRITE], R1
                MOV     R1, -1
                MOV     M[BOTAO], R1
                INC     R3
                MOV     R1, 1
                CMP     R3, R1
                BR.NZ   CONT_LAV
                MOV     R1, M[ANG]
                MOV     R4, 10             ; Se o contador for 1 o digito corresponde as dezenas
                MUL     R1, R4
                MOV     M[ANG], R4
                BR      LOOP_ANG
				
				MOV		R1, 90
				CMP		M[ANG], R1
				BR.NP	CONT_LAV
                
CONT_LAV:       MOV		R1, 90             ; O angulo nao pode ser superior a 90 graus
				CMP		M[ANG], R1
				BR.NP	INFERIOR_90
				MOV		M[ANG], R1
				
INFERIOR_90:	ADD     R2, 0103h
                
                PUSH    V_STRING
                MOV     R1, 0100h
                PUSH    R1
                CALL    ESCREVE_STRING
                
                MOV     R3, R0
LOOP_V:         CMP     M[BOTAO], R0
                BR.N    LOOP_V
                
                MOV     R1, M[BOTAO]
                ADD     M[V], R1
                ADD     R1, '0'
                ADD     R2, R3
                MOV     M[IO_CTRL], R2
                MOV     M[IO_WRITE], R1
                MOV     R1, -1
                MOV     M[BOTAO], R1
                INC     R3
                MOV     R1, 1
                CMP     R3, R1
                BR.NZ   FIM_LAV
                MOV     R1, M[V]
                MOV     R4, 10
                MUL     R1, R4
                MOV     M[V], R4
                BR      LOOP_V
                
FIM_LAV:        MOV     R1, FE00h
                AND     M[MASK], R1
                
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET
                 
;===============================================================================;
;                                Interrupcoes                                   ;
;===============================================================================;	
                  
INT_B0:         MOV     M[BOTAO], R0
                RTI
                                
INT_B1:         PUSH    R1

                MOV     R1, 1
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B2:         PUSH    R1

                MOV     R1, 2
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B3:         PUSH    R1

                MOV     R1, 3
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B4:         PUSH    R1

                MOV     R1, 4
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B5:         PUSH    R1

                MOV     R1, 5
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B6:         PUSH    R1

                MOV     R1, 6
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B7:         PUSH    R1

                MOV     R1, 7
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B8:         PUSH    R1

                MOV     R1, 8
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
                
INT_B9:         PUSH    R1

                MOV     R1, 9
                MOV     M[BOTAO], R1
				
                POP     R1
                RTI
               
INT_BA:         PUSH	R1

				INC     M[START]
				
				MOV		R1, FBFFh
				AND		M[MASK], R1
				
				POP		R1
                RTI
 
INT_TIMER:      PUSH    R1

                MOV     M[TIMER_COUNT],R0
                MOV     R1, 1
                MOV     M[TIMER_CTRL],R1
				
                CMP     M[ACERTOU], R1         ; Se a banana acertou no gorila fazer a animacao do gorila a "morrer"
				BR.NZ   DESENHAR_BANANA        ; Se nao desenhar a banana
                DEC     M[ACERTOU]
                BR      FIM_TIMER
DESENHAR_BANANA:MOV		R1, 11b
                ADD		M[T], R1
                CALL    BANANA
				
FIM_TIMER:      POP     R1

                RTI
                 
;===============================================================================;
;                             Parte um do Projeto                               ;
;===============================================================================;	
  			
func_pos:	    PUSH	R1
			    PUSH	R2
			    PUSH	R3
			    PUSH	R4
			    PUSH	R5
			    PUSH	R6
			    PUSH	R7
			    MOV		R1, M[SP + 10]
			    MOV		R2, M[SP + 11]
			    MOV		R3, M[SP + 13]
			    MOV		R4, M[SP + 12]
			    PUSH	R0
			    PUSH	R4
			    CALL	cos ; funcao para calcular o coseno do angulo
			    POP		R5
			    MOV		R6, R3
			    MOV		R7, R2
			    MUL		R6, R7
			    PUSH	R0
			    PUSH	R6
			    PUSH	R7
			    CALL	convert ; converter o resultado para guardalo num so registo
			    POP		R7
			    MUL		R5, R7
			    PUSH	R0
			    PUSH	R5
			    PUSH	R7
			    CALL	convert
			    POP		R7
			    ADD		R7, R1
			    MOV		M[SP + 15], R7
			    MOV		R1, M[SP + 9]
			    PUSH	R0
			    PUSH	R4
			    CALL	sin ; funcao para calcular o seno do angulo
			    POP		R5
			    MOV		R6, R3
			    MOV		R7, R2
			    MUL		R6, R7
			    PUSH	R0
			    PUSH	R6
			    PUSH	R7
			    CALL	convert
			    POP		R7
			    MUL		R5, R7
			    PUSH	R0
			    PUSH	R5
			    PUSH	R7
			    CALL	convert	
			    POP		R5
			    MOV		R6, R3
			    MOV		R7, R3
			    MUL		R6, R7
			    PUSH	R0
			    PUSH	R6
			    PUSH	R7
			    CALL	convert	
			    POP		R6
			    MOV		R7, 0000000100111001b ; R7 <- 4,9 = g/2
			    MUL		R6, R7
			    PUSH	R0
			    PUSH	R6
			    PUSH	R7
			    CALL	convert	
			    POP		R6
			    SUB		R5, R6
                ADD     R5, R1
			    MOV		M[SP + 14], R5
			    POP		R7
			    POP		R6
			    POP		R5
			    POP		R4
			    POP		R3
			    POP		R2
			    POP		R1
			    RETN	5
		
convert:	    PUSH	R1
			    PUSH	R2
			    PUSH	R3
			    MOV		R1, M[SP + 6]
			    MOV		R2, M[SP + 5]
			    MOV		R3, 6
cv_loop:	    DEC		R3
			    SHR		R1, 1
			    RORC	R2, 1
			    CMP 	R3, R0
			    BR.NZ	cv_loop
			    MOV		M[SP + 7], R2
			    POP		R3
			    POP		R2
			    POP		R1
			    RETN	2
			
sin:		    PUSH	R1
				PUSH	R2
				MOV		R1, M[SP + 4]
				SUB		R1, 90
				NEG		R1
				MOV		R2, TAB_COS
				ADD		R2, R1
                MOV     R1, M[R2]
				MOV		M[SP + 5], R1
				POP		R2
				POP		R1
				RETN	1
			
cos:		    PUSH	R1
				PUSH	R2
				MOV		R1, M[SP + 4]
				MOV		R2, TAB_COS
				ADD		R2, R1
                MOV     R1, M[R2]
				MOV		M[SP + 5], R1
				POP		R2
				POP		R1
				RETN	1
 