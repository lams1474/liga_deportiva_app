import prisma from "../config/prisma";

interface TareaResultado {
    id_resultado: number;
    id_partido: number;
}

class ResultadoWorker {

    private cola: TareaResultado[] = [];
    private procesando = false;

    agregarTarea(tarea: TareaResultado) {

        this.cola.push(tarea);

        console.log(
            `📥 Tarea agregada a la cola: resultado ${tarea.id_resultado}`
        );

        this.procesarCola();
    }

    private async procesarCola() {

        if (this.procesando) {
            return;
        }

        this.procesando = true;

        while (this.cola.length > 0) {

            const tarea = this.cola.shift();

            if (!tarea) {
                continue;
            }

            console.log(
                `⏳ Worker procesando resultado ${tarea.id_resultado}...`
            );

            try {
                await this.recalcularTablaPorPartido(tarea.id_partido);
                console.log(
                    `✅ Worker finalizó resultado ${tarea.id_resultado}`
                );
            } catch (error) {
                console.error(
                    `❌ Error en worker para resultado ${tarea.id_resultado}:`,
                    error
                );
            }
        }

        this.procesando = false;
    }

    /**
     * 🔥 Recalcula la tabla de posiciones completa para la temporada
     * del partido indicado.
     */
    private async recalcularTablaPorPartido(id_partido: number) {

        // 1. Obtener el partido con su resultado
        const partido = await prisma.partido.findUnique({
            where: { id_partido },
            include: { resultado: true }
        });

        if (!partido) {
            console.warn(`⚠️ Partido ${id_partido} no encontrado`);
            return;
        }

        const { id_temporada, id_club_local, id_club_visitante } = partido;
        const resultado = partido.resultado;

        console.log(`🔄 Recalculando tabla para temporada ${id_temporada}`);

        // 2. Obtener TODOS los partidos de esa temporada que ya tengan resultado
        const partidosConResultado = await prisma.partido.findMany({
            where: {
                id_temporada,
                resultado: {
                    isNot: null
                }
            },
            include: {
                resultado: true
            }
        });

        // 3. Obtener todos los clubes involucrados en esta temporada
        const clubsInvolucrados = new Set<number>();
        partidosConResultado.forEach(p => {
            clubsInvolucrados.add(p.id_club_local);
            clubsInvolucrados.add(p.id_club_visitante);
        });

        // Si el partido actual todavía no tiene resultado (recién eliminado),
        // igual queremos recalcular para los clubes del partido
        clubsInvolucrados.add(id_club_local);
        clubsInvolucrados.add(id_club_visitante);

        // 4. Inicializar estadísticas por club
        interface Estadisticas {
            puntos: number;
            pj: number;
            pg: number;
            pe: number;
            pp: number;
            gf: number;
            gc: number;
        }

        const stats = new Map<number, Estadisticas>();
        clubsInvolucrados.forEach(idClub => {
            stats.set(idClub, {
                puntos: 0,
                pj: 0,
                pg: 0,
                pe: 0,
                pp: 0,
                gf: 0,
                gc: 0,
            });
        });

        // 5. Procesar cada partido con resultado
        for (const p of partidosConResultado) {
            const r = p.resultado;
            if (!r || r.marcador_local === null || r.marcador_visitante === null) {
                continue;
            }

            const local = p.id_club_local;
            const visitante = p.id_club_visitante;
            const ml = r.marcador_local;
            const mv = r.marcador_visitante;

            const statsLocal = stats.get(local)!;
            const statsVisitante = stats.get(visitante)!;

            // PJ
            statsLocal.pj += 1;
            statsVisitante.pj += 1;

            // Goles
            statsLocal.gf += ml;
            statsLocal.gc += mv;
            statsVisitante.gf += mv;
            statsVisitante.gc += ml;

            // Resultado
            if (ml > mv) {
                // Gana local
                statsLocal.pg += 1;
                statsLocal.puntos += 3;
                statsVisitante.pp += 1;
            } else if (ml < mv) {
                // Gana visitante
                statsVisitante.pg += 1;
                statsVisitante.puntos += 3;
                statsLocal.pp += 1;
            } else {
                // Empate
                statsLocal.pe += 1;
                statsLocal.puntos += 1;
                statsVisitante.pe += 1;
                statsVisitante.puntos += 1;
            }
        }

        // 6. Actualizar o crear registros en tabla_posiciones
        for (const [idClub, s] of stats.entries()) {

            const existente = await prisma.tablaPosiciones.findFirst({
                where: {
                    id_temporada,
                    id_club: idClub,
                }
            });

            if (existente) {
                await prisma.tablaPosiciones.update({
                    where: { id_posicion: existente.id_posicion },
                    data: {
                        puntos: s.puntos,
                        pj: s.pj,
                        pg: s.pg,
                        pe: s.pe,
                        pp: s.pp,
                        gf: s.gf,
                        gc: s.gc,
                    }
                });
                console.log(`   ✅ Actualizado: club ${idClub} (${s.puntos} pts)`);
            } else {
                await prisma.tablaPosiciones.create({
                    data: {
                        id_temporada,
                        id_club: idClub,
                        puntos: s.puntos,
                        pj: s.pj,
                        pg: s.pg,
                        pe: s.pe,
                        pp: s.pp,
                        gf: s.gf,
                        gc: s.gc,
                    }
                });
                console.log(`   ✅ Creado: club ${idClub} (${s.puntos} pts)`);
            }
        }

        console.log(`✅ Tabla recalculada para temporada ${id_temporada}`);
    }
}

export const resultadoWorker = new ResultadoWorker();