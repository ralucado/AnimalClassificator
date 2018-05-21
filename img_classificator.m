function[Mdl] =  img_classificator()
    %obtenim els vectors de característiques dels animals
    PandaCarVec = getCarVec('/panda');
    KangarooCarVec = getCarVec('/kangaroo');
    FlamingoCarVec = getCarVec('/flamingo');
    EmuCarVec = getCarVec('/emu');
    ElephantCarVec = getCarVec('/elephant');
    DragonflyCarVec = getCarVec('/dragonfly');
    DolphinCarVec = getCarVec('/dolphin');
    CrocodileCarVec = getCarVec('/crocodile');
    CrayfishCarVec = getCarVec('/crayfish');
    CrabCarVec = getCarVec('/crab');
    BeaverCarVec = getCarVec('/beaver');
    AntCarVec = getCarVec('/ant');
    
    %creem vectors amb els mateixos tamanys amb les etiquetes de cada
    %especie
    %TO DO: Aqui els 10 s'han de canviar pel nombre d'imatges que haguem seleccionat per cada animal

    PandaEtiqVec(1:10) = "panda";
    KangarooEtiqVec(1:10) = "kangaroo";
    FlamingoEtiqVec(1:10) = "flamingo";
    EmuEtiqVec(1:10) = "emu";
    ElephantEtiqVec(1:10) = "elephant";
    DragonflyEtiqVec(1:10) = "dragon";
    DolphinEtiqVec(1:10) = "dolphin";
    CrocodileEtiqVec(1:10) = "crocodile";
    CrayfishEtiqVec(1:10) = "crayfish";
    CrabEtiqVec(1:10) = "crab";
    BeaverEtiqVec(1:10) = "beaver";
    AntEtiqVec(1:10) = "ant";
    
    
    %X conté la informació
    X = cat(1, PandaCarVec, KangarooCarVec, FlamingoCarVec, EmuCarVec, ElephantCarVec, DragonflyCarVec, DolphinCarVec, CrocodileCarVec, CrayfishCarVec, CrabCarVec, BeaverCarVec, AntCarVec);
    %Y conté les etiquetes
    Y = cat(1, PandaEtiqVec, KangarooEtiqVec, FlamingoEtiqVec, EmuEtiqVec, ElephantEtiqVec, DragonflyEtiqVec, DolphinEtiqVec, CrocodileEtiqVec, CrayfishEtiqVec, CrabEtiqVec, BeaverEtiqVec, AntEtiqVec);
    
    Mdl = fitcknn(X,Y,'NumNeighbors',5,'Standardize',1); %% Aixo està tal qual de la web, haurem de jugar amb els valors.
    
    %un cop fet descomentat la seguent línia i calculant el vector de caracteristiques de la imatge a predir podrem comprovar si fa bè les
    %prediccions
    
    %% prova = predict(Mdl, "vector de caracteristiques de la imatge a predir");
    %% display(prova);
end

function[carVecs] = getCarVec(path)

    %%Calculem el vector de característiques de les imatges de l'animal
    %%seleccionlat. 

    %%Carreguem les diferents imatges d'entrenament amb les anotacions
    %%corresponents, que aprofitarem per deduir algunes de les
    %%caractirístiques.
    
    
    for i=1:10  %% aqui enlloc de 10 hem de posar el nombre d'imatges de la carpeta
        if i < 10
            img = imgread(path + '/Train/image_000' + i);
            annotation = load(path + '/Train/annotation_000' + i);
        elseif i < 100
            img = imgread(path + '/Train/image_00' + i);
            annotation = load(path + '/Train/annotation_00' + i);
        elseif i < 1000
            img = imgread(path + '/Train/image_0' + i);
            annotation = load(path + '/Train/annotation_0' + i);
        else
            img = imgread(path + '/Train/image_' + i);
            annotation = load(path + '/Train/annotation_' + i);
        end
        
        %%obtenim el vector de característiques de la imatge i
        carVecs(i) = scan(img, annotation);
        
    end
end

function[carVec] = scan(img, annotation)
    
    %%obtenim l'alçada de l'animal
    height = annotation.box_coord(2) - annotation.box_coord(1);
    carVec.height = height;
    %obtenim la capça contenidora
    carVec.bounding_box = annotation.box_coord;
    
    %fem un crop de la bounding box per ignorar el background
    %de la imatge
    width = annotation.box_coord(4) - annotation.box_coord(3);
    xmin = annotation.box_coord(1);
    ymin = annotation.box_coord(3);
    cImg = imcrop(img, [xmin ymin width carVec.height]);
    
    
    %%obtenim l'area de l'animal i l'area respecte la capça contenidora
    
    %binaritzem la imatge
    bin = imbinarize(cImg);  %utilitza un mètode d'un tal Otsu per calcular el treshold, pero hauriem de buscarlo empiricament
    %obtenim l'àrea contant el numero de pixels de color blanc del
    %binaritzat
    carVec.area = sum(bin(:) == 1);
    %calculem també l'àrea relativa a la capsa contenidora
    carVec.areaRel = carVec.area/(widht*height);
    
    %contem el número de colors únics de la imatge
    [carVec.numColors, carVec.Colors] = getUniqueColors(cImg);
    
    %També calcularem propietats de textura utilitzant la funció
    %graycoprops
    
    %primer obtenim una matriu de co-ocurrencies en nivells de grisos de la
    %imatge
    grayM = graycomatrix(img);
    
    %ara obtenim les propietats
    textureCar = graycoprops(grayM);
    
    carVec.textureContrast = textureCar.contrast;
    carVec.textureCorrelatioln = textureCar.Correlation;
    carVec.textureEnergy = textureCar.Energy;
    carVec.textureHomogenity = textureCar.Homogeneity;
    
end

function[cont, colors] = getUniqueColors(img)
    %extraiem les components de color
    redCh = img(:,:,1);
    greenCh = img(:,:,2);
    blueCh = img(:,:,3);
    
    [rows, columns, x] = size(rgbImage);
    acum = zeros(256,256,256);
    %contem quants cops apareix cada color
    for i=1:rows
        for j=1:columns
            rIndex = redCh(i, j) + 1;
            gIndex = greenCh(i, j) + 1;
            bIndex = blueCh(i, j) + 1;
            acum(rIndex, gIndex, bIndex) = acum(rIndex, gIndex, bIndex) + 1;
        end
    end
    
    r = zeros(256, 1);
    g = zeros(256, 1);
    b = zeros(256, 1);
    cont = 1;
    %contem quants colors diferents hi ha i quins son
    for red = 1 : 256
        for green = 1: 256
            for blue = 1: 256
                if (acum(red, green, blue) > 1)
                    % Record the RGB position of the color.
                    r(nonZeroPixel) = red;
                    g(nonZeroPixel) = green;
                    b(nonZeroPixel) = blue;
                    cont = cont + 1;
                end
            end
        end
    end
    cont = cont - 1;
    colors = cat(3, r, g, b);
end