package pe.edu.upn.billetera.model;

import java.io.Serializable;

public class Movimiento implements Serializable {
    private static final long serialVersionUID = 1L;

    private String tipo;
    private double monto;

    public Movimiento() {
    }

    public Movimiento(String tipo, double monto) {
        this.tipo = tipo;
        this.monto = monto;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }
}
