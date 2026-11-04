package MonPremierModele {
    part def SystemeVelocommande {
        attribute poids : Real;
        port capteurVitesse;
    }

    part monVelocommande : SystemeVelocommande {
        poids = 12.5;
    }
}


