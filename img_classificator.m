function[X,Y] =  img_classificator()
    %obtenim els vectors de característiques dels animals
    PandaCarVec = getCarVec('panda/Train', 1, 28);
    KangarooCarVec = getCarVec('kangaroo/Train', 1, 66);
    FlamingoCarVec = getCarVec('flamingo/Train', 1, 51);
    EmuCarVec = getCarVec('emu/Train', 1, 40);
    ElephantCarVec = getCarVec('elephant/Train', 1, 49);
    DragonflyCarVec = getCarVec('dragonfly/Train', 1, 52);
    DolphinCarVec = getCarVec('dolphin/Train', 1, 50);
    CrocodileCarVec = getCarVec('crocodile/Train', 1, 38);
    CrayfishCarVec = getCarVec('crayfish/Train', 1, 54);
    CrabCarVec = getCarVec('crab/Train', 1, 56);
    BeaverCarVec = getCarVec('beaver/Train', 1, 34);
    AntCarVec = getCarVec('ant/Train', 1, 31);
    
    %creem vectors amb els mateixos tamanys amb les etiquetes de cada
    %especie
    PandaEtiqVec(1:28) = "panda";
    KangarooEtiqVec(1:66) = "kangaroo";
    FlamingoEtiqVec(1:51) = "flamingo";
    EmuEtiqVec(1:40) = "emu";
    ElephantEtiqVec(1:49) = "elephant";
    DragonflyEtiqVec(1:52) = "dragon";
    DolphinEtiqVec(1:50) = "dolphin";
    CrocodileEtiqVec(1:38) = "crocodile";
    CrayfishEtiqVec(1:54) = "crayfish";
    CrabEtiqVec(1:56) = "crab";
    BeaverEtiqVec(1:34) = "beaver";
    AntEtiqVec(1:31) = "ant";
   
    %X conté la informació
    X = cat(1, PandaCarVec, KangarooCarVec, FlamingoCarVec, EmuCarVec, ElephantCarVec, DragonflyCarVec, DolphinCarVec, CrocodileCarVec, CrayfishCarVec, CrabCarVec, BeaverCarVec, AntCarVec);
    %Y conté les etiquetes
    Y = [ PandaEtiqVec, KangarooEtiqVec, FlamingoEtiqVec, EmuEtiqVec, ElephantEtiqVec, DragonflyEtiqVec, DolphinEtiqVec, CrocodileEtiqVec, CrayfishEtiqVec, CrabEtiqVec, BeaverEtiqVec, AntEtiqVec];
end