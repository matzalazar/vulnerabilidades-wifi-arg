import os

def generar_diccionario(nombre_archivo):
    base_dir = os.path.dirname(os.path.abspath(__file__))            
    output_dir = os.path.join(base_dir, 'output')                    
    os.makedirs(output_dir, exist_ok=True)                          
    output_path = os.path.join(output_dir, nombre_archivo)           

    prefijos = ['004', '014', '044']
    inicio = 1500000
    fin = 4500000

    with open(output_path, 'w') as f:
        for prefijo in prefijos:
            for numero in range(inicio, fin):
                clave = f"{prefijo}{numero:07d}"
                f.write(clave + '\n')

    print(f"✅ Diccionario generado en: {output_path}")

if __name__ == "__main__":
    generar_diccionario("diccionario_isp.txt")
