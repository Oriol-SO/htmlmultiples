const fs = require('fs');
const path = require('path');

const targetFolder = 'paginas';
const outputFile = 'menu_data.js';

// Resolve the absolute path of the target folder (which is one level up from src/)
const basePath = path.resolve(__dirname, '../', targetFolder);

if (!fs.existsSync(basePath)) {
    console.error(`Error: La carpeta '${targetFolder}' no existe. Crea la carpeta primero.`);
    process.exit(1);
}

function getFolderTree(currentPath) {
    const items = fs.readdirSync(currentPath, { withFileTypes: true });
    const result = [];

    for (const item of items) {
        const itemPath = path.join(currentPath, item.name);
        // Calcular la ruta relativa para el iframe usando slashes normales
        const relativePath = path.relative(basePath, itemPath).split(path.sep).join('/');

        if (item.isDirectory()) {
            const children = getFolderTree(itemPath);
            if (children.length > 0) {
                result.push({
                    type: 'folder',
                    name: item.name,
                    children: children
                });
            }
        } else if (item.isFile() && item.name.endsWith('.html')) {
            result.push({
                type: 'file',
                name: item.name,
                path: `${targetFolder}/${relativePath}`
            });
        }
    }
    return result;
}

console.log(`Leyendo la carpeta '${targetFolder}'...`);
const tree = getFolderTree(basePath);

// Convertir a JSON
const json = JSON.stringify(tree, null, 0);
const jsContent = `const menuData = ${json};`;

// Escribir el archivo
fs.writeFileSync(path.resolve(__dirname, outputFile), jsContent, 'utf8');

console.log(`¡Menú actualizado exitosamente en '${outputFile}'!`);
