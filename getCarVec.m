function[carVecs] = getCarVec(path, iter, fi)
    disp('animal: '); disp(path);
    %%Calculem el vector de característiques de les imatges de l'animal
    %%seleccionlat. 

    %%Carreguem les diferents imatges d'entrenament amb les anotacions
    %%corresponents, que aprofitarem per deduir algunes de les
    %%caractirístiques.
    
    
    for i=iter:fi  %% aqui enlloc de 10 hem de posar el nombre d'imatges de la carpeta
        disp('analitzant imatge '); disp(i);
        if i < 10
            img = imread(strcat(path,'/image_000',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/annotation_000' , num2str(i)));
        else
            img = imread(strcat(path,'/image_00',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/annotation_00' , num2str(i)));
        end
        
        %%obtenim el vector de característiques de la imatge i
        carVecs(i, :) = scan(img, annotation);
        
    end
end