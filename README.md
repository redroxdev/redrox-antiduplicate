# 🛡️ RedRox Anti-Duplicate Weapon Holster

Script ligero y optimizado para **FiveM** diseñado para prevenir bugs, exploits o duplicación de armas al forzar a los jugadores a desarmarse automáticamente al entrar en zonas específicas (como arenas PvP o salidas de Paintball)[cite: 1].

---

## ✨ Características Principales

* **Desarme Automático:** Detecta cuando un jugador entra en el radio de una zona configurada y le obliga a guardar el arma (`WEAPON_UNARMED`) de forma instantánea.
* **Optimización Extrema:** Utiliza un bucle inteligente con tiempos de espera dinámicos (`sleep`) para asegurar un **consumo de 0.00ms** en reposo.
* **Sistema de Zonas Personalizables:** Configura fácilmente múltiples coordenadas con radios personalizados mediante `vector3`[cite: 2].
* **Herramienta de Depuración Visual (`/testzone`):** Incluye un comando integrado para visualizar los radios de las zonas en tiempo real dentro del juego (cilindros rojos para las zonas y verdes cuando estás dentro) facilitando enormemente la configuración de coordenadas[cite: 2].
* **Compatibilidad con Inventarios:** Preparado e integrado de forma opcional con sistemas populares como `ox_inventory`[cite: 2].

---

## ⚙️ Configuración (`client.lua`)

Puedes añadir o modificar las zonas protegidas directamente en la tabla `Zones` dentro del archivo `client.lua`[cite: 2]:

```lua
local Config = {
    Zones = {
        { coords = vector3(100.0, -1000.0, 30.0), radius = 5.0 }, -- Ejemplo zona 1
        { coords = vector3(250.5, -800.2, 30.0), radius = 7.5 },  -- Ejemplo zona 2
    },
    Debug = false
}
