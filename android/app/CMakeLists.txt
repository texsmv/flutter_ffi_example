cmake_minimum_required(VERSION 3.4.1)
add_library(
    mathFunctions # Nombre de la biblioteca
    SHARED # Indica que la biblioteca es compartida
    ../../native/math_functions.c # Direccion relativa de nuestro codigo fuente
)
