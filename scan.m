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
    %calculem la rectangularitat
    carVec.rectangularitat =  carVec.area/(r*c);
    %calculem la elongació
    carVec.elongacio = height/width;
    
    %i la corbatura (perimetre/canvis direccio)
    carVec.corbatura = perimeter/size(points, 1);
    
    %i la compactesa (perimetre^2/area)
    carVec.compactesa = perimeter^2/carVec.area;
    
    %obtenim els moments de hu (agafem només els dos primers)
    moms = feature_vec(points);
    carVec.M1 = moms(1);
    carVec.M2 = moms(2);
  
    %calculem el color de la imatge
    imh = rgb2hsv(img);
    %extraiem les components de color
    h = imh(:,:,1);
    carVec.color = mean(h(:));
    
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
 
    carVec2 = [carVec.rectangularitat, carVec.compactesa, carVec.corbatura, carVec.elongacio, carVec.M1, carVec.M2, carVec.color, carVec.textureContrast, carVec.textureCorrelation, carVec.textureEnergy, carVec.textureHomogenity];
    
end