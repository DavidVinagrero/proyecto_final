from tkinter import *
from tkinter import filedialog
import pandas as pd
import tkinter.ttk as ttk
from reportlab.lib.pagesizes import letter

# Configuración ventana
root = Tk()
root.title("Visualizador de diagramas")
root.iconbitmap("static/logo.ico")
root.geometry("500x500")

# Menu bar
menubar = Menu(root)
root.config(menu=menubar)


# Funciones menu bar
def abrir_csv():
    # Pedir al usuario que seleccione el archivo CSV
    filename = filedialog.askopenfilename(title="Seleccione un archivo CSV", filetypes=[("CSV Files", "*.csv")])

    # Leer el archivo CSV
    data = pd.read_csv(filename, delimiter=";")

    # Crear la tabla
    table = ttk.Treeview(root, columns=tuple(data.columns))

    # Agregar encabezados de columna
    for column in data.columns:
        table.heading(column, text=column)

    # Agregar datos a la tabla
    for i, row in data.iterrows():
        table.insert("", "end", text=i, values=tuple(row))

    # Mostrar la tabla
    titulo = Label(root, text="Tabla de Incidencias", font=("Arial", 14))
    table.
    titulo.pack()
    table.pack()



file_menu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="Archivo", menu=file_menu)

file_menu.add_command(label="Abrir", command=abrir_csv)
file_menu.add_command(label="Guardar")
file_menu.add_separator()
file_menu.add_command(label="Salir", command=root.quit)

root.mainloop()
