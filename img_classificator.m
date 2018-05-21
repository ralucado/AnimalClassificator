function[Mdl] =  img_classificator()
    %obtenim els vectors de caracter�stiques dels animals
    PandaCarVec = getCarVec('panda');
    KangarooCarVec = getCarVec('kangaroo');
    FlamingoCarVec = getCarVec('flamingo');
    EmuCarVec = getCarVec('emu');
    ElephantCarVec = getCarVec('elephant');
    DragonflyCarVec = getCarVec('dragonfly');
    DolphinCarVec = getCarVec('dolphin');
    CrocodileCarVec = getCarVec('crocodile');
    CrayfishCarVec = getCarVec('crayfish');
    CrabCarVec = getCarVec('crab');
    BeaverCarVec = getCarVec('beaver');
    AntCarVec = getCarVec('ant');
    
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
    
    
    %X cont� la informaci�
    X = cat(1, PandaCarVec, KangarooCarVec, FlamingoCarVec, EmuCarVec, ElephantCarVec, DragonflyCarVec, DolphinCarVec, CrocodileCarVec, CrayfishCarVec, CrabCarVec, BeaverCarVec, AntCarVec);
    %Y cont� les etiquetes
    Y = [ PandaEtiqVec, KangarooEtiqVec, FlamingoEtiqVec, EmuEtiqVec, ElephantEtiqVec, DragonflyEtiqVec, DolphinEtiqVec, CrocodileEtiqVec, CrayfishEtiqVec, CrabEtiqVec, BeaverEtiqVec, AntEtiqVec];
   
    Mdl = fitcknn(X,Y);
    %un cop fet descomentat la seguent l�nia i calculant el vector de caracteristiques de la imatge a predir podrem comprovar si fa b� les
    %prediccions
    
    % prova = predict(Mdl, "vector de caracteristiques de la imatge a predir");
    % display(prova);
end

function[carVecs] = getCarVec(path)
    disp('animal: '); disp(path);
    %%Calculem el vector de caracter�stiques de les imatges de l'animal
    %%seleccionlat. 

    %%Carreguem les diferents imatges d'entrenament amb les anotacions
    %%corresponents, que aprofitarem per deduir algunes de les
    %%caractir�stiques.
    
    
    for i=1:10  %% aqui enlloc de 10 hem de posar el nombre d'imatges de la carpeta
        disp('analitzant imatge '); disp(i);
        if i < 10
            img = imread(strcat(path,'/Train/image_000',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/Train/annotation_000' , num2str(i)));
        elseif i < 100
            img = imread(strcat(path,'/Train/image_00',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/Train/annotation_00' , num2str(i)));
        elseif i < 1000
            img = imread(strcat(path,'/Train/image_0',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/Train/annotation_0' , num2str(i)));
        else
            img = imread(strcat(path,'/Train/image_',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/Train/annotation_' , num2str(i)));
        end
        
        %%obtenim el vector de caracter�stiques de la imatge i
        carVecs(i, :) = scan(img, annotation);
        
    end
end

function[carVec2] = scan(img, annotation)
    
    [a b x] = size(img);
    if x == 1
        cmap = gray(256);
        img = ind2rgb(img, cmap);
        img = uint8(img);
    end

    %%obtenim l'al�ada de l'animal
    height = annotation.box_coord(2) - annotation.box_coord(1);
    carVec.height = height;
    %obtenim la cap�a contenidora
    carVec.bounding_box = annotation.box_coord;
    
    %fem un crop de la bounding box per ignorar el background
    %de la imatge
    width = annotation.box_coord(4) - annotation.box_coord(3);
    xmin = annotation.box_coord(1);
    ymin = annotation.box_coord(3);
    cImg = imcrop(img, [xmin ymin width carVec.height]);
    
    
    %%obtenim l'area de l'animal i l'area respecte la cap�a contenidora
    
    %binaritzem la imatge
    bin = imbinarize(cImg);  %utilitza un m�tode d'un tal Otsu per calcular el treshold, pero hauriem de buscarlo empiricament
    %obtenim l'�rea contant el numero de pixels de color blanc del
    %binaritzat
    carVec.area = sum(bin(:) == 1);
    %calculem tamb� l'�rea relativa a la capsa contenidora
    carVec.areaRel = carVec.area/(width*height);
    
    %contem el n�mero de colors �nics de la imatge
    carVec.numColors = getUniqueColors(cImg);
    
    %Tamb� calcularem propietats de textura utilitzant la funci�
    %graycoprops
    
    %primer obtenim una matriu de co-ocurrencies en nivells de grisos de la
    %imatge
    
    grayM = graycomatrix(rgb2gray(img));
    
    %ara obtenim les propietats
    textureCar = graycoprops(grayM);
    
    carVec.textureContrast = textureCar.Contrast;
    carVec.textureCorrelatioln = textureCar.Correlation;
    carVec.textureEnergy = textureCar.Energy;
    carVec.textureHomogenity = textureCar.Homogeneity;
    
    carVec2 = [height, carVec.bounding_box, carVec.area,  carVec.areaRel, carVec.numColors, carVec.textureContrast, carVec.textureContrast, carVec.textureEnergy, carVec.textureHomogenity];
    
end

function[cont] = getUniqueColors(img)
    %extraiem les components de color
    redCh = img(:,:,1);
    greenCh = img(:,:,2);
    blueCh = img(:,:,3);
    
    [rows, columns, x] = size(img);
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
                    %r(cont) = red;
                    %g(cont) = green;
                    %b(cont) = blue;
                    cont = cont + 1;
                end
            end
        end
    end
    cont = cont - 1;
    %colors = cat(3, r, g, b);
end