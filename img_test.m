X = []; Y = [];
load XAllCars;
load Y;

CarVecs = []; EtiqVecs = [];
load testAllCars;
load testEtiqVecs;

Mdl = fitcdiscr(X,Y);

certs = 0;
falsos = 0;

for i = 1:138
    prova = predict(Mdl, CarVecs(i,:));
    if (prova == EtiqVecs(i))
        certs = certs +1;
    else
        falsos = falsos + 1;
    end
end

display("% Error:");
display(falsos*100/(certs+falsos));

function[] = loadTestVecs()   
    PandaCarVec = getCarVec('panda', 29, 36);
    KangarooCarVec = getCarVec('kangaroo', 67, 83);
    FlamingoCarVec = getCarVec('flamingo', 52, 64);
    EmuCarVec = getCarVec('emu', 41, 50);
    ElephantCarVec = getCarVec('elephant', 50, 61);
    DragonflyCarVec = getCarVec('dragonfly', 53, 65);
    DolphinCarVec = getCarVec('dolphin', 51, 62);
    CrocodileCarVec = getCarVec('crocodile', 39, 47);
    CrayfishCarVec = getCarVec('crayfish', 55, 67);
    CrabCarVec = getCarVec('crab', 57, 70);
    BeaverCarVec = getCarVec('beaver', 35, 43);
    AntCarVec = getCarVec('ant', 32, 39);
    
    %creem vectors amb els mateixos tamanys amb les etiquetes de cada
    %especie
    PandaEtiqVec(1:8) = "panda";
    KangarooEtiqVec(1:17) = "kangaroo";
    FlamingoEtiqVec(1:13) = "flamingo";
    EmuEtiqVec(1:10) = "emu";
    ElephantEtiqVec(1:12) = "elephant";
    DragonflyEtiqVec(1:13) = "dragon";
    DolphinEtiqVec(1:12) = "dolphin";
    CrocodileEtiqVec(1:9) = "crocodile";
    CrayfishEtiqVec(1:13) = "crayfish";
    CrabEtiqVec(1:14) = "crab";
    BeaverEtiqVec(1:9) = "beaver";
    AntEtiqVec(1:8) = "ant";
    
    CarVecs = [PandaCarVec; KangarooCarVec; FlamingoCarVec; EmuCarVec; ElephantCarVec; DragonflyCarVec; DolphinCarVec; CrocodileCarVec; CrayfishCarVec; CrabCarVec; BeaverCarVec; AntCarVec];
    EtiqVecs = [PandaEtiqVec, KangarooEtiqVec, FlamingoEtiqVec, EmuEtiqVec, ElephantEtiqVec, DragonflyEtiqVec, DolphinEtiqVec, CrocodileEtiqVec, CrayfishEtiqVec, CrabEtiqVec, BeaverEtiqVec, AntEtiqVec];
end



function[] = single_img_test(path, i)
    global Mdl;
    img = imread(strcat(path,'/image_00',num2str(i), '.jpg'));
    annotation = load(strcat(path,'/annotation_00',num2str(i)));

    carVec=scan(img, annotation);

    prova = predict(Mdl, carVec);
    display(prova);
end

function[carVecs] = getCarVec(path, iter, fi)
    disp('animal: '); disp(path);
    %%Calculem el vector de característiques de les imatges de l'animal
    %%seleccionlat. 

    %%Carreguem les diferents imatges d'entrenament amb les anotacions
    %%corresponents, que aprofitarem per deduir algunes de les
    %%caractirístiques.
    
    
    for i=iter:fi 
        disp('analitzant imatge '); disp(i);
        if i < 10
            img = imread(strcat(path,'/image_000',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/annotation_000' , num2str(i)));
        else
            img = imread(strcat(path,'/image_00',num2str(i), '.jpg'));
            annotation = load(strcat(path , '/annotation_00' , num2str(i)));
        end
        %%obtenim el vector de característiques de la imatge i
        carVecs((i - iter)+1, :) = scan(img, annotation);
        
    end

    
end

function[carVec2] = scan(img, annotation)
    
    [~, ~, x] = size(img);
    if x == 1
        cmap = gray(256);
        img = ind2rgb(img, cmap);
        img = uint8(img);
    end

    %%obtenim l'alçada de l'animal
    height = annotation.box_coord(2) - annotation.box_coord(1);
    carVec.height = height;
    
    %fem un crop de la bounding box per ignorar el background
    %de la imatge
    width = annotation.box_coord(4) - annotation.box_coord(3);
    xmin = annotation.box_coord(1);
    ymin = annotation.box_coord(3);
    cImg = imcrop(img, [xmin ymin width carVec.height]);
    [r, c] = size(cImg);
    
    %%obtenim el perimetre de l'animal
    
    points = annotation.obj_contour;

    perimeter = 0;

    for i = 1:size(points, 1)-1

    perimeter = perimeter + norm(points(i, :) - points(i+1, :));

    end

    perimeter = perimeter + norm(points(end, :) - points(1, :)); % Last point to first
    
    
    
    %obtenim l'area de l'animal i l'area respecte la capça contenidora
    carVec.area = polyarea(points(1,:), points(2,:));
    carVec.areaRatio =  carVec.area/(r*c);
    %i la corbatura (perimetre/canvis direccio)
    carVec.corbatura = perimeter/size(points, 1);
    
    %i la compacitat (perimetre^2/area)
    carVec.compacitat = perimeter^2/carVec.area;
    
    %contem el número de colors únics de la imatge
    carVec.numColors = getUniqueColors(cImg);
    
    %També calcularem propietats de textura utilitzant la funció
    %graycoprops
    
    %primer obtenim una matriu de co-ocurrencies en nivells de grisos de la
    %imatge
    
    grayM = graycomatrix(rgb2gray(img));
    
    %ara obtenim les propietats
    textureCar = graycoprops(grayM);
    
    carVec.textureContrast = textureCar.Contrast;
    carVec.textureCorrelation = textureCar.Correlation;
    carVec.textureEnergy = textureCar.Energy;
    carVec.textureHomogenity = textureCar.Homogeneity;
    
    carVec2 = [carVec.areaRatio, carVec.compacitat, carVec.corbatura, carVec.numColors, carVec.textureContrast, carVec.textureCorrelation, carVec.textureEnergy, carVec.textureHomogenity];
    
end

function[cont] = getUniqueColors(img)
    %extraiem les components de color
    redCh = img(:,:,1);
    greenCh = img(:,:,2);
    blueCh = img(:,:,3);
    
    [rows, columns, ~] = size(img);
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