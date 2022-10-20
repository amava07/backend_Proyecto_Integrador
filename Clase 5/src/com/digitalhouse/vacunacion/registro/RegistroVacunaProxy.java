package com.digitalhouse.vacunacion.registro;

import com.digitalhouse.vacunacion.model.Persona;

import java.util.Date;

public class RegistroVacunaProxy implements Registro {
    Persona persona;
    // PreRegistro de Vacunaciñon para validar los datos y luego llamar a Registro de vacunacion
    @Override
    public void registrar(Object[] datos) {
        if (comprobarFecha((Date) (datos[1]))) {
            RegistroVacuna registro = new RegistroVacuna();
            registro.registrar(datos);
        }
    }

    public boolean comprobarFecha(Date fecha) {
        return fecha.before(new Date());
    }
}
