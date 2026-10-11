# Invasion de los Xhar'Kor — Android

Videojuego de combate espacial creado con Processing para teléfonos Android. El jugador pilota el caza F2, defiende la Tierra en cinco niveles y puede llegar a uno de dos desenlaces: victoria o derrota.

## Características

- Cinco niveles con dificultad progresiva y una batalla final contra el crucero del emperador.
- Dos finales con sus respectivas secuencias: victoria y derrota.
- Controles táctiles con joystick y botones de ráfaga, misil y láser.
- Movimiento y disparo simultáneos mediante multitáctil.
- Pausa, reanudación y reinicio desde la interfaz del juego.
- Audio, animaciones, explosiones y escenas entre niveles.
- Orientación horizontal y elementos de interfaz adaptados a diferentes tamaños de pantalla.

## Requisitos

- Processing instalado.
- Android Mode de Processing.
- Un dispositivo Android para ejecutar el juego; también se puede generar un APK desde Processing.

La versión Android usa funciones propias del modo Android de Processing, como `touches[]`, `openKeyboard()` y `SoundPool`. No se debe abrir ni compilar con Java Mode.

## Ejecutar el juego

1. Descarga o clona el repositorio.
2. En Processing, abre `InvasionXharKorAndroid.pde` desde esta carpeta.
3. Selecciona Android Mode.
4. Conecta un dispositivo Android o configura un emulador compatible.
5. Ejecuta el sketch. Para generar un APK, usa las opciones de exportación de Android Mode.

Mantén juntas las carpetas `data` y `code` y los archivos `.pde`: el juego carga sus imágenes y sonidos desde `data`.

## Controles

| Control | Acción |
| --- | --- |
| Joystick inferior izquierdo | Mover el caza |
| **RÁFAGA** | Disparar el arma principal |
| **MISIL** | Lanzar misiles de alto daño |
| **LÁSER** | Disparar el láser |
| Botón superior | Pausar o reanudar |
| Botón **REINICIAR** al terminar | Comenzar una partida nueva |

Se puede mover el caza y disparar a la vez usando dos dedos.

## Estructura del proyecto

```text
InvasionXharKorAndroid/
├── InvasionXharKorAndroid.pde   # Entrada del sketch Android
├── Game.pde                    # Estados, niveles y finales
├── Player.pde                  # Nave del jugador
├── Enemy.pde                   # Enemigos y jefe final
├── Bullet.pde                  # Proyectiles y armas
├── TouchControls.pde           # Controles táctiles
├── SoundManager.pde            # Audio del juego
├── EventMessage.pde            # Diálogos y mensajes
├── Explosion.pde               # Efectos de explosión
├── data/                       # Imágenes, música y efectos de sonido
└── code/                       # Bibliotecas del sketch
```

## Publicar en GitHub

Para que GitHub muestre estas instrucciones al entrar al repositorio, conserva este archivo con el nombre `README.md` en la raíz del repositorio. Si publicas el proyecto Android como repositorio independiente, usa el contenido completo de esta carpeta como raíz e incluye `data/` y `code/`.

Antes de publicar, confirma que tienes permiso para distribuir todos los recursos gráficos y de audio incluidos. No subas claves de firma, contraseñas ni archivos privados. Si compartes un APK, publícalo como una versión (Release) de GitHub e indica el dispositivo y la versión del juego con que lo generaste.

## Créditos y licencia

Completa esta sección con los nombres de las personas autoras y la licencia elegida antes de distribuir el juego públicamente.
