%% Preparar Classificador
%Carreguem les caracteristiques de les imatge d'entrenament
X = []; Y = [];
load XAllCars;
load Y;
%Seleccionem les caracteristiques que ens interessen
newX = [X(:,1), X(:,2),X(:,3),X(:,4), X(:,5)]; 
%Entrenem el classificador
Mdl = fitcdiscr(newX,Y);
%% Preparar la imatge per el test
path = input('Escriu entre cometes simples el path de la imatge\n');
img = imread(path);
path = input('Escriu entre cometes simples el path de la anotacio\n');
annotation = load(path);
CarVec=scan(img, annotation);
%Seleccionem les caracteristiques que ens interessen
CarVec = [CarVec(:,1),CarVec(:,2),CarVec(:,3),CarVec(:,4), CarVec(:,5)];
%% Fer el Test
prova = predict(Mdl, CarVec);
display(prova);