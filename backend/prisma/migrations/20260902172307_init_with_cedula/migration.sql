-- CreateTable
CREATE TABLE `Usuario` (
    `id_usuario` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100) NOT NULL,
    `correo` VARCHAR(100) NOT NULL,
    `contrasena` VARCHAR(255) NOT NULL,
    `rol` VARCHAR(191) NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `Usuario_correo_key`(`correo`),
    PRIMARY KEY (`id_usuario`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Club` (
    `id_club` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100) NOT NULL,
    `ciudad` VARCHAR(100) NOT NULL,
    `fecha_fundacion` DATE NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `Club_nombre_key`(`nombre`),
    PRIMARY KEY (`id_club`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Jugador` (
    `id_jugador` INTEGER NOT NULL AUTO_INCREMENT,
    `cedula` VARCHAR(20) NOT NULL,
    `nombre` VARCHAR(100) NOT NULL,
    `ciudad` VARCHAR(100) NOT NULL,
    `fecha_nacimiento` DATE NOT NULL,
    `id_club` INTEGER NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `Jugador_cedula_key`(`cedula`),
    INDEX `Jugador_id_club_idx`(`id_club`),
    PRIMARY KEY (`id_jugador`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Disciplina` (
    `id_disciplina` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(20) NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `Disciplina_nombre_key`(`nombre`),
    PRIMARY KEY (`id_disciplina`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Categoria` (
    `id_categoria` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `id_disciplina` INTEGER NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id_categoria`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Temporada` (
    `id_temporada` INTEGER NOT NULL AUTO_INCREMENT,
    `año` INTEGER NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `Temporada_año_key`(`año`),
    PRIMARY KEY (`id_temporada`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Arbitro` (
    `id_arbitro` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100) NOT NULL,
    `categoria` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id_arbitro`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Partido` (
    `id_partido` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha` DATE NOT NULL,
    `hora` VARCHAR(10) NOT NULL,
    `lugar` VARCHAR(200) NOT NULL,
    `id_categoria` INTEGER NOT NULL,
    `id_club_local` INTEGER NOT NULL,
    `id_club_visitante` INTEGER NOT NULL,
    `id_temporada` INTEGER NOT NULL,
    `id_arbitro` INTEGER NOT NULL,
    `programado_por` INTEGER NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id_partido`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Resultado` (
    `id_resultado` INTEGER NOT NULL AUTO_INCREMENT,
    `id_partido` INTEGER NOT NULL,
    `marcador_local` INTEGER NULL,
    `marcador_visitante` INTEGER NULL,
    `registrado_por` INTEGER NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `Resultado_id_partido_key`(`id_partido`),
    PRIMARY KEY (`id_resultado`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `JugadorDisciplina` (
    `id_jugador` INTEGER NOT NULL,
    `id_disciplina` INTEGER NOT NULL,

    PRIMARY KEY (`id_jugador`, `id_disciplina`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TablaPosiciones` (
    `id_posicion` INTEGER NOT NULL AUTO_INCREMENT,
    `id_temporada` INTEGER NOT NULL,
    `id_club` INTEGER NOT NULL,
    `puntos` INTEGER NOT NULL DEFAULT 0,
    `pj` INTEGER NOT NULL DEFAULT 0,
    `pg` INTEGER NOT NULL DEFAULT 0,
    `pe` INTEGER NOT NULL DEFAULT 0,
    `pp` INTEGER NOT NULL DEFAULT 0,
    `gf` INTEGER NOT NULL DEFAULT 0,
    `gc` INTEGER NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `TablaPosiciones_id_temporada_id_club_key`(`id_temporada`, `id_club`),
    PRIMARY KEY (`id_posicion`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Jugador` ADD CONSTRAINT `Jugador_id_club_fkey` FOREIGN KEY (`id_club`) REFERENCES `Club`(`id_club`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Categoria` ADD CONSTRAINT `Categoria_id_disciplina_fkey` FOREIGN KEY (`id_disciplina`) REFERENCES `Disciplina`(`id_disciplina`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Partido` ADD CONSTRAINT `Partido_id_categoria_fkey` FOREIGN KEY (`id_categoria`) REFERENCES `Categoria`(`id_categoria`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Partido` ADD CONSTRAINT `Partido_id_club_local_fkey` FOREIGN KEY (`id_club_local`) REFERENCES `Club`(`id_club`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Partido` ADD CONSTRAINT `Partido_id_club_visitante_fkey` FOREIGN KEY (`id_club_visitante`) REFERENCES `Club`(`id_club`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Partido` ADD CONSTRAINT `Partido_id_temporada_fkey` FOREIGN KEY (`id_temporada`) REFERENCES `Temporada`(`id_temporada`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Partido` ADD CONSTRAINT `Partido_id_arbitro_fkey` FOREIGN KEY (`id_arbitro`) REFERENCES `Arbitro`(`id_arbitro`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Partido` ADD CONSTRAINT `Partido_programado_por_fkey` FOREIGN KEY (`programado_por`) REFERENCES `Usuario`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Resultado` ADD CONSTRAINT `Resultado_id_partido_fkey` FOREIGN KEY (`id_partido`) REFERENCES `Partido`(`id_partido`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Resultado` ADD CONSTRAINT `Resultado_registrado_por_fkey` FOREIGN KEY (`registrado_por`) REFERENCES `Usuario`(`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JugadorDisciplina` ADD CONSTRAINT `JugadorDisciplina_id_jugador_fkey` FOREIGN KEY (`id_jugador`) REFERENCES `Jugador`(`id_jugador`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JugadorDisciplina` ADD CONSTRAINT `JugadorDisciplina_id_disciplina_fkey` FOREIGN KEY (`id_disciplina`) REFERENCES `Disciplina`(`id_disciplina`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TablaPosiciones` ADD CONSTRAINT `TablaPosiciones_id_temporada_fkey` FOREIGN KEY (`id_temporada`) REFERENCES `Temporada`(`id_temporada`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TablaPosiciones` ADD CONSTRAINT `TablaPosiciones_id_club_fkey` FOREIGN KEY (`id_club`) REFERENCES `Club`(`id_club`) ON DELETE RESTRICT ON UPDATE CASCADE;
