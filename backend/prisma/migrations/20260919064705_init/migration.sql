-- AlterTable
ALTER TABLE `Club` ADD COLUMN `latitud` FLOAT NULL,
    ADD COLUMN `longitud` FLOAT NULL,
    ADD COLUMN `precision_ubicacion` VARCHAR(20) NULL,
    ADD COLUMN `presidente` VARCHAR(100) NULL;
