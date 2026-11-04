
package ATMD_Flux_Gestion {

    private import ScalarValues::Boolean;

    action gererAutorisations {

        attribute possedeDroits : Boolean;
        attribute aucunDroit : Boolean;
        attribute modifier : Boolean;
        attribute supprimer : Boolean;

        action selectionnerUtilisateur;
        action verifierDroits;
        action choisirSalle;
        action modifierDroits;
        action supprimerAcces;
        action enregistrerModification;
        action afficherAucunDroit;

        decide decisionDroits;
        decide decisionModification;

        merge fusionModification;
        merge finGestion;

        first start;

        succession start then selectionnerUtilisateur;

        succession selectionnerUtilisateur
            then verifierDroits;

        succession verifierDroits
            then decisionDroits;

        succession decisionDroits
            if aucunDroit then afficherAucunDroit;

        succession afficherAucunDroit
            then finGestion;

        succession decisionDroits
            if possedeDroits then choisirSalle;

        succession choisirSalle
            then decisionModification;

        succession decisionModification
            if modifier then modifierDroits;

        succession decisionModification
            if supprimer then supprimerAcces;

        succession modifierDroits
            then fusionModification;

        succession supprimerAcces
            then fusionModification;

        succession fusionModification
            then enregistrerModification;

        succession enregistrerModification
            then finGestion;

        succession finGestion then done;
    }
}
