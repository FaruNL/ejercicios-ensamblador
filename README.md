# ejercicios-ensamblador

Ejercicios en 8086 Assembly

## Contenido

- **Actividades** 
    - Operaciones con cadena usando el ratón.
    - Menú de operaciones (2 versiones).
- **OK**
    - *Extendido:* Ejercicios usando el formato completo.
    - *Small:* Ejercicios usando el modelo `.SMALL`.
    - *Cadenas:* Ejercicios sencillos con cadenas.
    - Ejercicios extra y plantillas de programa.
- **BIN**
    - *MASM611:* Macro Assembler
    - *TASM:* Turbo Assembler
    - *TC:* Turbo C
    - *Other:* Scripts varios y debugger
        - *D.bat:* Elimina los archivos `.OBJ` y `.EXE` asociados a cierto archivo `.ASM`.
        - *R.bat:* Abreviación de `rescan`.
        - *E.bat* Ensambla (TASM) y liga (MASM) dado el nombre de un archivo `.ASM`.
- **dosbox-0.74-3.conf** *(Configuración de DOSBOX)*
    - *autolock:* Si está activado permite que el ratón no salga de la ventana de DOSBOX. (Recomiendo apagarlo)
        ```conf
        autolock=false
        ```
    - *keyboardLayout:* Cambia la disposición del teclado en DOSBOX
        ```conf
        # Disposición española
        keyboardlayout=sp

        # Disposición latina
        keyboardlayout=la
        ```
    - *[autoexec]:* Comandos que se ejecutan al abrir DOSBOX
        - Cambia `~/DOSBOX` por la ruta donde DOSBOX tomará como `C:`
        - Ubica la carpeta BIN de este repositorio en la carpeta anteriormente mencionda.
        ```conf
        [autoexec]
        mount c ~/DOSBOX
        C:
        PATH=%PATH%;C:\BIN\OTHER;C:\BIN\MASM611\BIN;C:\BIN\TASM\BIN;        C:\BIN\TC\BIN;C:\BIN\TC\INCLUDE;C:\BIN\TC\LIB
        ```
