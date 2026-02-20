# Conversión de Capas CAD (DWG/DXF) a Shapefile en QGIS

## Generación de Sectores, Manzanas y Lotes

**Entorno:** QGIS\
**Sistema de Referencia:** WGS 84 / UTM Zona 19S (EPSG:32719)\
**Formato de salida:** ESRI Shapefile

------------------------------------------------------------------------

## 1. Conversión previa del archivo CAD

### 1.1 Importar archivo CAD en QGIS

Ruta:

QGIS → Proyecto → Importar/Exportar → Importar DWG/DXF

Si aparece el error:

"Falló la importación de dibujos (incompatible 2018, 2019, 2020)"

### 1.2 Convertir versión CAD

Utilizar **ODA File Converter** y convertir el archivo a versión
**AutoCAD 2013**.

Luego volver a importar en QGIS seleccionando:

-   SRC: WGS 84 / UTM Zone 19S (EPSG:32719)

------------------------------------------------------------------------

## 2. Generación de capa Sector

### 2.1 Exportar polilíneas

1.  Clic derecho sobre la capa CAD\
2.  Exportar → Guardar capa vectorial como...\
3.  Formato: ESRI Shapefile\
4.  Nombre: sector_polilinea\
5.  Exportar solo la columna: fid

### 2.2 Convertir líneas a polígonos

Vectorial → Geometry Tools → Líneas a Polígonos

Entrada: sector_polilinea\
Salida: sector_poligono

### 2.3 Unir atributos por localización

Vectorial → Unir atributos por localización

-   Capa objetivo: sector_poligono\
-   Capa de unión: puntos/textos\
-   Predicado geométrico: Intersecan

### 2.4 Crear campo cod_sector

Abrir Calculadora de Campos:

-   Crear nuevo campo\
-   Nombre: cod_sector\
-   Tipo: Texto\
-   Longitud: 2

Validación:

length("cod_sector") = 2

------------------------------------------------------------------------

## 3. Generación de capa Manzana

### 3.1 Exportar polilíneas

Nombre: manzana_polilinea\
Campo base: fid

### 3.2 Convertir a polígono

Vectorial → Geometry Tools → Líneas a Polígonos

### 3.3 Crear campos obligatorios

  Campo         Tipo    Longitud
  ------------- ------- ----------
  cod_sector    Texto   2
  cod_manzana   Texto   3

Validaciones:

length("cod_sector") = 2\
length("cod_manzana") = 3

------------------------------------------------------------------------

## 4. Generación de capa Lotes

### 4.1 Exportar desde CAD

Nombre: lotes_polilinea\
Campo base: fid

### 4.2 Convertir a polígono

Vectorial → Geometry Tools → Líneas a Polígonos

### 4.3 Crear campos obligatorios

  Campo         Tipo    Longitud
  ------------- ------- ----------
  cod_sector    Texto   2
  cod_manzana   Texto   3
  cod_lote      Texto   3

Validaciones:

length("cod_sector") = 2\
length("cod_manzana") = 3\
length("cod_lote") = 3

------------------------------------------------------------------------

## 5. Estructura Final Requerida

### Sector

  Campo        Longitud
  ------------ ----------
  cod_sector   2

### Manzana

  Campo         Longitud
  ------------- ----------
  cod_sector    2
  cod_manzana   3

### Lote

  Campo         Longitud
  ------------- ----------
  cod_sector    2
  cod_manzana   3
  cod_lote      3

------------------------------------------------------------------------

## 6. Recomendaciones Técnicas

-   Validar geometrías:\
    Vectorial → Geometry Tools → Validar geometrías

-   Verificar que no existan superposiciones\

-   No usar espacios ni tildes en nombres de archivo\

-   Mantener siempre EPSG:32719\

-   Validar que no existan espacios en blanco en los códigos
