-- CreateIndex
CREATE INDEX `Arbitro_nombre_idx` ON `Arbitro`(`nombre`);

-- CreateIndex
CREATE INDEX `Arbitro_categoria_idx` ON `Arbitro`(`categoria`);

-- CreateIndex
CREATE INDEX `Categoria_nombre_idx` ON `Categoria`(`nombre`);

-- CreateIndex
CREATE INDEX `Club_ciudad_idx` ON `Club`(`ciudad`);

-- CreateIndex
CREATE INDEX `Jugador_nombre_idx` ON `Jugador`(`nombre`);

-- CreateIndex
CREATE INDEX `Jugador_fecha_nacimiento_idx` ON `Jugador`(`fecha_nacimiento`);

-- CreateIndex
CREATE INDEX `Partido_fecha_idx` ON `Partido`(`fecha`);

-- CreateIndex
CREATE INDEX `TablaPosiciones_puntos_idx` ON `TablaPosiciones`(`puntos`);

-- CreateIndex
CREATE INDEX `Usuario_rol_idx` ON `Usuario`(`rol`);

-- RenameIndex
ALTER TABLE `Categoria` RENAME INDEX `Categoria_id_disciplina_fkey` TO `Categoria_id_disciplina_idx`;

-- RenameIndex
ALTER TABLE `JugadorDisciplina` RENAME INDEX `JugadorDisciplina_id_disciplina_fkey` TO `JugadorDisciplina_id_disciplina_idx`;

-- RenameIndex
ALTER TABLE `Partido` RENAME INDEX `Partido_id_arbitro_fkey` TO `Partido_id_arbitro_idx`;

-- RenameIndex
ALTER TABLE `Partido` RENAME INDEX `Partido_id_categoria_fkey` TO `Partido_id_categoria_idx`;

-- RenameIndex
ALTER TABLE `Partido` RENAME INDEX `Partido_id_club_local_fkey` TO `Partido_id_club_local_idx`;

-- RenameIndex
ALTER TABLE `Partido` RENAME INDEX `Partido_id_club_visitante_fkey` TO `Partido_id_club_visitante_idx`;

-- RenameIndex
ALTER TABLE `Partido` RENAME INDEX `Partido_id_temporada_fkey` TO `Partido_id_temporada_idx`;

-- RenameIndex
ALTER TABLE `Partido` RENAME INDEX `Partido_programado_por_fkey` TO `Partido_programado_por_idx`;

-- RenameIndex
ALTER TABLE `Resultado` RENAME INDEX `Resultado_registrado_por_fkey` TO `Resultado_registrado_por_idx`;

-- RenameIndex
ALTER TABLE `TablaPosiciones` RENAME INDEX `TablaPosiciones_id_club_fkey` TO `TablaPosiciones_id_club_idx`;
