function[]=makeTest()
%Carreguem els vectors de caracteristiques precomputats
    X = []; Y = [];
    load XAllCars;
    load Y;

    CarVecs = []; EtiqVecs = [];
    load testAllCars;
    load testEtiqVecs;

    newX = [X(:,1), X(:,2),X(:,3),X(:,4), X(:,5)]; 
    newCarVecs = [CarVecs(:,1),CarVecs(:,2),CarVecs(:,3),CarVecs(:,4), CarVecs(:,5)];
    Mdl = fitcdiscr(newX,Y);

    certs = 0;
    falsos = 0;
    matConf = zeros(12:12);
    for i = 1:138
        prova = predict(Mdl, newCarVecs(i,:));
        if (prova == EtiqVecs(i))
            certs = certs +1;
        else
            falsos = falsos + 1;
        end
        numGuessed = animalToIndex(prova);
        numCorr = animalToIndex(EtiqVecs(i));
        matConf(numCorr, numGuessed) =  matConf(numCorr, numGuessed) + 1; 
    end

    display("% Error:");
    display(falsos*100/(certs+falsos));

    for i = 1:549
    ind(i) = animalToIndex(Y(i));
    end
end



function[i] = animalToIndex(animal)
    i = 0;
    if(animal == "panda")
        i = 1;
    elseif (animal == "kangaroo")
        i = 2;
    elseif (animal == "flamingo")
        i = 3;
    elseif (animal == "emu")
        i = 4;
    elseif (animal == "elephant")
        i = 5;
    elseif (animal == "dragon")
        i = 6;
    elseif (animal == "dolphin")
        i = 7;
    elseif (animal == "crocodile")
        i = 8;
    elseif (animal == "crayfish")
        i = 9;
    elseif (animal == "crab")
        i = 10;
    elseif (animal == "beaver")
        i = 11;
    else
        i = 12;
    end
end

function[] = loadBulkTestVecs()       
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