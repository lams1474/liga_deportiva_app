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

            await new Promise(resolve => setTimeout(resolve, 1500));

            console.log(
                `✅ Worker finalizó resultado ${tarea.id_resultado}`
            );
        }

        this.procesando = false;
    }
}

export const resultadoWorker = new ResultadoWorker();