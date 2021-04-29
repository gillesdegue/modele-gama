/***
* Name: ModelMobilite
* Author: GILLES
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model ModelMobilite

global {
	
	file shape_file_zone_mer <- file("../includes/shapefileMer.shp");
	file shape_file_zone_gambie <- file("../includes/gambie.shp");
	file shape_file_zone_guinee <- file("../includes/guinee.shp");
	file shape_file_zone_guinee_bissau <- file("../includes/guinee_bissau.shp");
	file shape_file_zone_maroc <- file("../includes/maroc.shp");
	file shape_file_zone_mauritanie <- file("../includes/mauritanie.shp");
	file shape_file_zone_sahara_occidentale <- file("../includes/sahara_occidentale.shp");
	file shape_file_zone_administrative <- file("../includes/zoneAdministrative.shp");
	
	file shape_file_NomVilleSenegal <- csv_file("../includes/villesSenegal.csv");
    file shape_file_villeSenegal <- file("../includes/villesSenegal.shp");
    
    file shape_file_NomVilleSenegal2 <- csv_file("../includes/villesSenegal2.csv");
    file shape_file_villeSenegal2 <- file("../includes/villesSenegal2.shp");
    
    file shape_file_villesSahara_occidentale <- file("../includes/villesSahara_occidentale.shp");
    file shape_file_NomVillesSahara_occidentale <- csv_file("../includes/villesSahara_occidentale.csv");
    
    file shape_file_VillesMauritanie <- file("../includes/VillesMauritanie.shp");
    file shape_file_NomVillesMauritanie <- csv_file("../includes/VillesMauritanie.csv");
    
    file shape_file_villesMaroc <- file("../includes/villesMaroc.shp");
    file shape_file_NomVillesMaroc <- csv_file("../includes/villesMaroc.csv");
    
    file shape_file_villesGuinee <- file("../includes/villesGuinee.shp");
    file shape_file_NomVillesGuinee <- csv_file("../includes/villesGuinee.csv");
    
    file shape_file_point_profondeur_temperature <- file("../includes/temperatures.shp");
    csv_file csv_profondeur_temperature <- csv_file("../includes/bathy_sst_month_SENEGAL_MEAN.csv");
    geometry shape <- envelope(shape_file_zone_administrative);
	
	//liste des sites de debarquement 
	file sitesDeDebarquement <- csv_file("../includes/sitesDeDebarquement.csv");
	// recuperation de l'image illustrant les sites de debarquement et recuperation de l'image illustrant les especes cibles
	file ImageSiteDeDebarquement <- image_file("../includes/siteDeDebarquement.jpg");
	file ImagePoisson <- image_file("../includes/poisson.jpg");
	file Imagebateau <- image_file("../includes/bateau.jpg");
	//********************************************************************************************************
		//le mois sera utiliser avecc with dans le init pour choisir la colone de temperature a utiliser
		int mois <-1;
		int index_mois_actuelle<- 1;
		 int nbrLieuxDePecheSardinelle <- 500;
	  	 int nbrLieuxDePecheThiof <- 500;
	  	 int nbrpecheurs <- 5;
	  	 float beta <- 0.0001;
	  	 int heur<-0;
	  	 int jour<-1;
	  	 int annee <-1;
	  	 float offreSardinelleMoisT <- 0.0 ;
	  	 float offreSardinelleMoisTMoin1 <- 0.0 ;
		 float offreThiofMoisT <- 0.0 ;
		 float offreThiofMoisTMoin1 <- 0.0 ;
		 float ValeurOffreSardinelleMoisT<-0;
		 float ValeurOffreThiofMoisT<-0;
		 float ValeurOffreSardinelleJour<-0;
		 float ValeurOffreThiofJour<-0;
		 /*
		  * vvariables
		  */
		  float patrimoineValeurMoisDakar<-0;
		  float patrimoineValeurMoisSaintLouis<-0;
		  float patrimoineValeurMoisMbour<-0;
		  float patrimoineValeurMoisBanjul<-0;
		  
		  float ValeurOffreThiofJourDakar<-0;
		  float ValeurOffreThiofJourSaintLouis<-0;
		  float ValeurOffreThiofJourMbour<-0;
		  float ValeurOffreThiofJourBanjul<-0;
		  
		  
		  
		  int ValeurNbrPecheurDakar<-5;
		  int ValeurNbrPecheurMbour<-5;
		  int ValeurNbrPecheurSaintLouis<-5;
		  int ValeurNbrPecheurBanjul<-5;
		  /*
		   * 
		   */
	  	 //servira a savoir si pendant une periode tel ou tel espece de poisson n'existe pas
	  	 bool existSandrinelle<-true;
	  	 bool existThiof <-true;
	  	 
	  	 bool mobilite<-false;
	  	 int capaciteMaxLieuDePecheSardinelle<-100;
	  	 int capaciteActuelleLieuDePeche<-100;
	  	 int d<-0;
	//********************************************************************************************************
	//initialisation des cotes ,sites de debarquement et bateaux
	action initialisationCotesEtVilles {
		
  	  create mer from:shape_file_zone_mer;
	  create zonesAdministratives from: shape_file_zone_administrative;
      create gambie from: shape_file_zone_gambie ;
      create guinee from: shape_file_zone_guinee ;
      create guinee_bissau from: shape_file_zone_guinee_bissau ;
      create maroc from: shape_file_zone_maroc ;
      create mauritanie from: shape_file_zone_mauritanie ;
      create sahara_occidentale from: shape_file_zone_sahara_occidentale ;
     
      int compteur;
            //liste des agents sites de debarquement
	  list<ville> listeSitesDebarquement <- []  ;
      compteur <- 2;
     //ville senegal
      create ville from: shape_file_villeSenegal{
      	 int index_element_de_ligne_csv <- 4*compteur;
      	nom <- shape_file_NomVilleSenegal.contents[index_element_de_ligne_csv-4];
      	compteur <- compteur+1;
      	loop site from: 0 to: length(sitesDeDebarquement)-2 { 
     	if nom = sitesDeDebarquement.contents[site]{
     		add self to:  listeSitesDebarquement;
     		nbrBateau <-  int(sitesDeDebarquement.contents[site+1]);
     	}
}
      	 
      }
      //ville senegal du second fichier shapefile
      compteur <- 2;
    create ville from: shape_file_villeSenegal2{
      	 int index_element_de_ligne_csv <- 2*compteur;
      	nom <- shape_file_NomVilleSenegal2.contents[index_element_de_ligne_csv-2];
      	compteur <- compteur+1;
      	loop site from: 0 to: length(sitesDeDebarquement)-1 step: 2 { 
     	if nom = sitesDeDebarquement.contents[site]{
     		
     		add self to:  listeSitesDebarquement;
     		nbrBateau <-  int(sitesDeDebarquement.contents[site+1]);
     	}
      }
      }
      //ville sahara occidental
      compteur <- 2;
      create ville from: shape_file_villesSahara_occidentale{
      	 int index_element_de_ligne_csv <- 2*compteur;
      	nom <- shape_file_NomVillesSahara_occidentale.contents[index_element_de_ligne_csv-2];
      	compteur <- compteur+1;
      	loop site from: 0 to: length(sitesDeDebarquement)-1 step: 2 { 
     	if nom = sitesDeDebarquement.contents[site]{
     		
     		add self to:  listeSitesDebarquement;
     	}
      	}
      }
      //mauritanie
      compteur <- 2;
      create ville from: shape_file_VillesMauritanie{
      	 int index_element_de_ligne_csv <- 2*compteur;
      	nom <- shape_file_NomVillesMauritanie.contents[index_element_de_ligne_csv-2];
      	compteur <- compteur+1;
      	loop site from: 0 to: length(sitesDeDebarquement)-2 { 
     	if nom = sitesDeDebarquement.contents[site]{
     		add self to:  listeSitesDebarquement;
     	}
      	}
      }
      
       //maroc
      compteur <- 2;
      create ville from: shape_file_villesMaroc{
      	 int index_element_de_ligne_csv <- 2*compteur;
      	nom <- shape_file_NomVillesMaroc.contents[index_element_de_ligne_csv-2];
      	compteur <- compteur+1;
      	loop site from: 0 to: length(sitesDeDebarquement)-2 { 
     	if nom = sitesDeDebarquement.contents[site]{
     		add self to:  listeSitesDebarquement;
     	}
      	}
      }
      
       //guinee
      compteur <- 2;
      create ville from: shape_file_villesGuinee{
      	 int index_element_de_ligne_csv <- 2*compteur;
      	nom <- shape_file_NomVillesGuinee.contents[index_element_de_ligne_csv-2];
      	compteur <- compteur+1;
      	loop site from: 0 to: length(sitesDeDebarquement)-2 { 
     	if nom = sitesDeDebarquement.contents[site]{
     		add self to:  listeSitesDebarquement;
     	}
      	}
      	
      }
      
         //creation des bateaux
    
	   loop sitesDebarquement over: listeSitesDebarquement {
	   	 loop j from: 0 to: int(sitesDebarquement.nbrBateau)-1 {
	   	 	 create bateau   {
	   	 	 	location <- sitesDebarquement.location;
	   	 	 	SitesDebarquement <- listeSitesDebarquement;
	   	 	 	
	   	 	 }
	     	}
		}
	}
	//creation des points de temperature
	action initialisationPointsTemperature {
  	  int compteur<- 1;
      create point_profondeur_temperature from: shape_file_point_profondeur_temperature  {
       		//i me permet de savoir a quelle element du shapefile je suis
       		//l'index_element_de_ligne_csv permet de savoir a quelle index du csvfile correspond celle de i
       
           int index_element_de_ligne_csv <- 15*compteur;
           
           lon<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-15]); 
           lat<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-14]); 
           bathy<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-13]); 
           SSTM1<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-12]); 
           SSTM2<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-11]); 
           SSTM3<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-10]); 
           SSTM4<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-9]); 
           SSTM5<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-8]); 
           SSTM6<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-7]);
           SSTM7<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-6]);
           SSTM8<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-5]);
           SSTM9<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-4]);
           SSTM10<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-3]);
           SSTM11<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-2]); 
           SSTM12<- float(csv_profondeur_temperature.contents[index_element_de_ligne_csv-1]);
           //Adaptation de la couleur au debut de la simulation
		   if SSTM1 <=20 {color<-rgb(1,65,130);}
		   if SSTM1 > 20 and SSTM1 <= 25 {color<-rgb(10,100,165);}
		   if SSTM1 > 25 {color<-rgb(0,3,91);}
		   //valeur initiale de la temperature mois 1
		   temperature_actuelle<-SSTM1;
       compteur<-compteur+1;
    } 
	}
	
	action initialisationLieuxDePeche {
		list<point_profondeur_temperature> listeLieuxPecheSardinelle <- point_profondeur_temperature where(each.temperature_actuelle >= 18 and each.temperature_actuelle <=24 and each.bathy <=200 and each.lat>12 and each.lat<16 and each.lon > -17);
		list<point_profondeur_temperature> listeLieuxPecheThiof <- point_profondeur_temperature where(each.temperature_actuelle >= 16 and each.temperature_actuelle <=21 and each.bathy <=1000 and each.lat>12 and each.lat<16 and each.lon > -17);
		//creation des sardinelles
		if length(listeLieuxPecheSardinelle) != 0{
		create lieuxDePeche number: nbrLieuxDePecheSardinelle{
      	location <- any_location_in(one_of(listeLieuxPecheSardinelle));
      	nom <-"Sardinelle";
      	capaciteActuelle <- capaciteActuelleLieuDePeche;
      	capaciteTotale <- capaciteMaxLieuDePecheSardinelle;
      }
      }
      if length(listeLieuxPecheThiof) != 0{
      //creation des thiof
      create lieuxDePeche number: nbrLieuxDePecheThiof{
      	location <- any_location_in(one_of(listeLieuxPecheThiof));
      	nom <-"Thiof";
      	capaciteActuelle <- 30;
      	capaciteTotale <- 30;
      }
      }
	}
	
	reflex temps{
		
		
		//La simulation s'arrete apres une annee
		if mois<=12{
		if heur< 24 {
			heur <- heur+1;
		}
		if heur = 24{
			
			heur<-0;
			jour<- jour + 1;
			
			//valeur de poissons peche
			//pour la sardinelle
			
			 
			
			if jour = 30{
				//recuperation du nombre de pecheurs par sites de debarquement
				list<pecheur> lpecheur <- pecheur where(each.siteDebarquementOrigine.nom = "Dakar");
			 ValeurNbrPecheurDakar <- length(lpecheur);
			 
			
			 lpecheur <- pecheur where(each.siteDebarquementOrigine.nom = "M'Bour");
			 ValeurNbrPecheurMbour <- length(lpecheur);
			 
			
			 lpecheur <- pecheur where(each.siteDebarquementOrigine.nom = "Banjul");
			 ValeurNbrPecheurBanjul <- length(lpecheur);
			
			 lpecheur <- pecheur where(each.siteDebarquementOrigine.nom = "Saint Louis");
			 ValeurNbrPecheurSaintLouis <- length(lpecheur);
			
			jour<-0;
			mois <- mois + 1;
			
			
			 ValeurOffreSardinelleJour<-0;
		     ValeurOffreThiofJour<-0;
			
			
			
			
			}
		}
		
	}
}
	
	reflex changementDeMois{
		//verification si la temperature dans point_profondeur_temperature est a jours avant la redistribution des lieux de peche
		bool TemperatureMisAJours<-false;
		if index_mois_actuelle != mois{
		
	    	ask point_profondeur_temperature{
	    	 		if self.index_mois_actuelle = mois{
	    	 			TemperatureMisAJours <-true;
	    	 		}
	    	 	}
	    	 
	    	 //recuperation de tout les leux de peche
	    	list<lieuxDePeche>listeLieuxPeche <-lieuxDePeche where(each.nom !="");
	    	 if TemperatureMisAJours = true{
	    	 	list<point_profondeur_temperature> listeLieuxPecheSardinelle <- point_profondeur_temperature where(each.temperature_actuelle >= 18 and each.temperature_actuelle <=24 and each.bathy <=200 and each.lat>12 and each.lat<16 and each.lon > -17);
				list<point_profondeur_temperature> listeLieuxPecheThiof <- point_profondeur_temperature where(each.temperature_actuelle >= 16 and each.temperature_actuelle <=21 and each.bathy <=1000 and each.lat>12 and each.lat<16 and each.lon > -17);
		
		//redistribution des lieux de peche
	    	 	loop site over: listeLieuxPeche {
	    	 		if site.nom = "Sardinelle"{
	    	 			if length(listeLieuxPecheSardinelle)!=0{
							existSandrinelle<-true;
					      	site.location <- any_location_in(one_of(listeLieuxPecheSardinelle));
					      	 
					       
					     }else{
					     	existSandrinelle<-false;
					     }
	    	 		       	 		
	    	 		}
	    	 		if site.nom = "Thiof"{
	    	 			if length(listeLieuxPecheThiof)!=0{
	    	 				existThiof<-false;
					      	site.location <- any_location_in(one_of(listeLieuxPecheThiof));
					      	
	    	 			}else{
	    	 				existThiof<-false;
	    	 			}
	    	 		
	    	 		}
	    	 	}
	    	 	TemperatureMisAJours <-false;
	    	 	index_mois_actuelle <- mois;
	    	 }
		} 
	}
  init{
 //initialisation de l'environnement
  	 do initialisationCotesEtVilles;
  	 do initialisationPointsTemperature;
  	 do initialisationLieuxDePeche;
   

      
   
    
    create pecheur number: nbrpecheurs{
    	
    	especeCible<- "Sardinelle";
    	 villeDeDepart <- one_of(ville where(each.nom = "Dakar"));
    	 siteDebarquementOrigine<-villeDeDepart;
     	location <- any_location_in(villeDeDepart);
      
  	}
  	 
  	create pecheur number: nbrpecheurs{
    	
    	especeCible<- "Sardinelle";
    	 villeDeDepart <- one_of(ville where(each.nom = "M'Bour"));
    	 siteDebarquementOrigine<-villeDeDepart;
     	location <- any_location_in(villeDeDepart);
      
  	}
  	create pecheur number: nbrpecheurs{
    	
    	especeCible<- "Sardinelle";
    	 villeDeDepart <- one_of(ville where(each.nom = "Saint Louis"));
    	 siteDebarquementOrigine<-villeDeDepart;
     	location <- any_location_in(villeDeDepart);
      
  	}
  	create pecheur number: nbrpecheurs{
    	
    	especeCible<- "Sardinelle";
    	 villeDeDepart <- one_of(ville where(each.nom = "Banjul"));
    	 siteDebarquementOrigine<-villeDeDepart;
     	location <- any_location_in(villeDeDepart);
      
  	}

  }
}



species zonesAdministratives {
	rgb color <- #gray ;
	aspect base {
        draw shape color: color border: #black;
    }
}




species pecheur skills: [moving] {
	/***************************************
	 * anciennent variable
	 *  */
	rgb color <- #red ;
	ville villeDeDepart;
	string ethnie;
	bool is_au_site_de_debarquement<-false;
	float quantiteEspeceCible<-0.0;
	float capaciteFinanaciere<-0.0;
	ville siteDebarquementActuel<-nil;
	ville siteDebarquementOrigine<-nil;
	bateau engin <-nil;
	lieuxDePeche cible<-nil;
	string especeCible;
	int compteurDePAs<- 0;
	ville siteCible<-nil;
	ville ancienSiteCible<-nil;
	int jourT <- 0;
	int compteurNbrDebarquement <- 0;
	int jourDeRepos<-0;
	list<lieuxDePeche> LieuxPecheAEviter;
	
	init{
		jourDeRepos<- rnd(1,7);
		speed<- 0.19;
		capaciteFinanaciere <- 1000000.0;
	}
	aspect base {
			if siteDebarquementActuel != nil {
    		//draw circle(0.05) color: color ;
    		
    		}
  
    }
    //si il debarque 7 jour d'affilé
    reflex strategieMobiliteTerre{
    
    	//prise en compe du jour de repos
    	
    		if jour = jourDeRepos or jour = (jourDeRepos+7) or jour = (jourDeRepos+14) or  jour = (jourDeRepos+21){
    					jourT <- jour; 
    				}	
	
    	if compteurNbrDebarquement = 6{
    		//mis a jour du site de debarquement d'origine
    		siteDebarquementOrigine <-siteCible;
    		compteurNbrDebarquement <- 0;
    	
    	}	
    	
    	
    }
    
    reflex strategieMobiliteMer{
    	float depense;
    	if (especeCible = "Sardinelle" and existSandrinelle = false) or (especeCible = "Thiof" and existThiof = false ) {
    			location<-siteDebarquementOrigine.location;
    			siteDebarquementActuel<-siteDebarquementOrigine;
    			 siteCible<-nil;
    			 quantiteEspeceCible<-0.0;
    		}else{
    	try{
    	do atSiteDebarquement;
    	
    	//prise en compte des heurs de repos et des jours de repos
    	if siteDebarquementActuel !=nil and quantiteEspeceCible = 0 and heur>6 and heur<14 and jour!= jourDeRepos and jour!= jourDeRepos+7 and jour!= jourDeRepos+14 and jour!= jourDeRepos+21 {
    		//calcul du budjet
    		 depense <- calculBudjetAller() as float;
    		
    		//verification si la capacite financiere depasse les depenses de la campagne
    		if verifCapaciteFinanciere(depense) = true{
    			if recuperationBateau(depense) != false{
    				//deplacement vers le lieux de peche cible	
    			do deplacementVersCible;
    			}else{
    				//recuperation des frais de campagne si le pecheur ne trouve pas de lieu de peche
    				capaciteFinanaciere<- capaciteFinanaciere +depense;
    			}
    			
    		}
    		}
    		//deplacement jusqu au lieux de peche
    		if siteDebarquementActuel =nil and quantiteEspeceCible = 0 {
    			do deplacementVersCible;
    		}
    		//quand le pecheur arrive au lieux de peche et n' a pas encore peché
    		
    		if self.location = cible.location and quantiteEspeceCible = 0{
    			
    			//les 6 pas permettent de tenir compte des 6 heurs de peche
    			compteurDePAs <- compteurDePAs +1;
    			//reinitialisation du compteur de pas apres 6h de peche
    			if compteurDePAs = 7{
    				compteurDePAs<-1;
    			}
    			if compteurDePAs = 6{
    				do peche;
    			}
    			
    		}
    		
    		
    		//si il est au lieu de peche et qu'il a l'espece cible
    		if self.location = cible.location and quantiteEspeceCible != 0{
    			//si il y a mobilite
    			if mobilite = true{
    				//quand il a peché et qu'il doit evaluer la rentabilité
    				do rechercheSiteRentable;
    			}else if mobilite = false{
    				//si il n y a pas de mobilite
    				siteCible <- siteDebarquementOrigine ;
    			}
			    /*
			     * 
			     */
			    //si il se fait tard il ne rentre pas.il reste sur le lieux de peche
			    if heur>6 and heur<20{
			    do deplacementVersSiteDebarquement;
	    	 		
	    	 	}
    		}
    		
    		//si il avait deja commence a bouger du site de debarquement avant 20h il continue son retour
			    if self.location != cible.location and quantiteEspeceCible != 0{
			    do deplacementVersSiteDebarquement;
			    }
    		
    		//quand il arrive sur le site de debarquement et qu'il veut vendre,on verifie si l'offre est inferieur a le demande
    		//max avant de vendre
    		try { 
    		if location = siteCible.location and quantiteEspeceCible != 0{
    			//verifie si il revient sur le meme site de debarquement en fonction des jours pour la mobilite sur terre
    			//cas ou ce n'est pas le meme que l'ancien
    			if ancienSiteCible != siteCible{
    				ancienSiteCible <- siteCible;
    				jourT <-jour;
    				compteurNbrDebarquement <-0;
    				//cas ou c est le meme que l'ancien
    			}else if ancienSiteCible = siteCible{
    				//si c est le jour suivant
    				if jour = (jourT + 1){
    					//nombre de fois qu'un pecheur debarque sur un meme site
    					compteurNbrDebarquement <- compteurNbrDebarquement +1;
    					jourT <- jour;
    					
    				}
    			}
    			//le site cible devient le site de debarquement actuel
    			siteDebarquementActuel <- siteCible;
    			do venteEspeceCible(depense);
    			
    			
    		}		
    	
    	}
    	}
    }
    }
    //verification si le pecheur est a un site de debarquement
    action atSiteDebarquement{
    	list<ville> ListsiteDeDebarquement <- ville where(each.isSiteDeDebarquement = true);
    	loop site over: ListsiteDeDebarquement {
   	 		if self.location = site.location{
   	 			 siteDebarquementActuel <- site;
   	 			 break;
   	 		}
		}
    }
    //vente d'espece cible sur un marché
    action venteEspeceCible(float depense){
    	ask siteCible{
    			
    				if myself.especeCible ="Sardinelle" {
    					//dans le cas ou l'offre est inferieur a la demande
    					if offreSardinelle < demandeMaxSardinelle{
    						//mis a jour de l'offre en ajoutant la quantite peché
    						offreSardinelle <- offreSardinelle + myself.quantiteEspeceCible;
    						
    						
    						//vente sur le marche
    						/*
    						 * vu que les especes cibles sont vendu par lot de 10 kilo sur le marche 
    						 * et que le pecheur amene par tonne,
    						 * sachant que 1 tonne = 1000 kilo, quantite par 10 kilo = 1tonne/10 
    						 */
    						 //vente et recuperation du benefice
    						myself.capaciteFinanaciere <- myself.capaciteFinanaciere+( prixSardinelle * (myself.quantiteEspeceCible * 100));
    						myself.quantiteEspeceCible <- 0.0;
    					}
    					}
    					
    					if myself.especeCible ="Thiof"{
    						//si l'offre est inferieur a la demande maximale
    						if offreThiof < demandeMaxThiof{
    						offreThiof <- offreThiof + myself.quantiteEspeceCible;
    						
    						 
    						myself.capaciteFinanaciere <- prixThiof * (myself.quantiteEspeceCible * 100);
    						myself.quantiteEspeceCible <- 0.0;
    						
			    			
    					}
    					}
    					
    					// si l'offre est superieur a la demande maximale il subissent des pertes
    					if offreSardinelle >= demandeMaxSardinelle or offreThiof >= demandeMaxThiof {
    						myself.quantiteEspeceCible <- 0.0;
    					}
    					
    			}
    }
    //recherche de bateau
    action recuperationBateau(float depense){
    	list<bateau> liste_bateaux_dispo <- bateau where( each.location = siteDebarquementActuel.location);
    	if length(liste_bateaux_dispo)!=0 {
    		engin <- one_of(liste_bateaux_dispo);
    		if depense = 300000{
    			// chargement du carburant en fonction de la distance du lieu de peche
    			ask engin{
    				self.carburant <- 8;
    			}
    		}
    		
    		if depense = 600000{
    			ask engin{
    				self.carburant <- 16;
    			}
    		}
    		
    		if depense = 900000{
    			ask engin{
    				self.carburant <- 24;
    			}
    		}
    		
    		if depense = 1200000{
    			ask engin{
    				self.carburant <- 32+5;
    			}
    		}
    	}else{
    		return false;
    	}
    }
    //recherche du site de debarquement le plus rentable
    action rechercheSiteRentable{
    	//recuperation de tout les sites de debarquement
	    list<ville> ListsiteDeDebarquement <- ville where(each.isSiteDeDebarquement = true);
	    list<ville> ListsiteDeMemePrix ;
	    			float prixLePlusHaut<-0.0;
	    			int distance;
	    			siteCible<-nil;
	    			
	    			loop site over: ListsiteDeDebarquement {
	    				//verification si le site de debarquement atteignable avec la quantite d'essence restant
	    				distance <- calculDistanceRetour(site)as int;
	    				ask engin{
	    					//si le pecheur peut atteindre le site de debarquement
	    					if self.carburant > distance or self.carburant = distance{
	    						if myself.especeCible ="Sardinelle" and prixLePlusHaut < site.prixSardinelle{
	    							//recuperation du site de debarquement avec le prix le plus haut
	    							prixLePlusHaut<- site.prixSardinelle; 
	    						myself.siteCible <- site;
	    					}
	    					//dans le cas ou plusieurs sites ont le meme prix
	    					if myself.especeCible ="Sardinelle" and prixLePlusHaut = site.prixSardinelle and prixLePlusHaut!=0{
	    						add site to: ListsiteDeMemePrix;	
	    					}
	    					
	    					//dans le cas du thiof
	    					if myself.especeCible ="Thiof" and prixLePlusHaut < site.prixThiof{
	    						prixLePlusHaut<- site.prixSardinelle;
	    						myself.siteCible <- site;
	    					}
	    					
	    					if myself.especeCible ="Thiof" and prixLePlusHaut = site.prixThiof and prixLePlusHaut!=0 {
	    						add site to: ListsiteDeMemePrix;
	    					}
	    					}
	    				}
				    }
				    //si il y a des sites qui ont les meme prix, il va au plus proche
				    if length(ListsiteDeMemePrix)>0{
				    	//on ajoute le premier site qu il a trouver avec un prix eleve dans la liste pour pouvoir trouver
				    	//celui qui est reelement le plus proche
				    	add siteCible to: ListsiteDeMemePrix;
				    	//si tout les sites ont le meme prix il se dirige vers le plus proche
				    	siteCible <- one_of( ListsiteDeMemePrix closest_to(self,1));
				    }
				    // si apres avoir verifier il se rend compte que les site ou il peut aller on tous on prix de 0 il va la ou
				    //c est le plus proche
				    if siteCible = nil{
				    	siteCible <- ListsiteDeDebarquement closest_to self;
				    }
    	
    }
    //verification de la capacite financiere avant le depart du lieux de peche
     action verifCapaciteFinanciere(float depense){
     //si la depense est inferieur a la capacite de pecheur la fonction retourne true	
    if depense <  capaciteFinanaciere{
    			
    		capaciteFinanaciere <- capaciteFinanaciere - depense;
    		return true;
    		
    		
    		}
    }
    //deplacement vers le lieu de peche cible
    action deplacementVersCible{
	    do goto target: cible; 
	    				ask engin {
		    	 			self.location <- myself.location;
		    	 			myself.siteDebarquementActuel <-nil;
		    	 		}
    }
    //deplacement vers le site de devarquement cible
    action deplacementVersSiteDebarquement{
	    do goto target: siteCible; 
			    ask engin {
	    	 			self.location <- myself.location;
	    	 		}
    }
    //quantite que peut recuperer un pecheur en fonction de la quantite d'espece au lieu de peche
    action peche{
	    ask cible{
	    					if self.nom = "Sardinelle" and myself.especeCible ="Sardinelle" {
	    						myself.quantiteEspeceCible <- self.capaciteActuelle * 0.3  ;
	    						self.capaciteActuelle <- self.capaciteActuelle - myself.quantiteEspeceCible  ;
	    						//si le site de debarquement n a plus assez de poisson il l'evite
	    						if self.capaciteActuelle< 0.5{
	    							add self to: myself.LieuxPecheAEviter;
	    						}
	    					}
	    					
	    					if self.nom = "Thiof" and myself.especeCible ="Thiof" {
	    						
	    						myself.quantiteEspeceCible <- self.capaciteActuelle * 0.3  ;
	    						self.capaciteActuelle <- self.capaciteActuelle - myself.quantiteEspeceCible  ;
	    					}
	      				}
    }
    //calcul du budjet en fonction de la distance
    action calculBudjetAller{
    list<lieuxDePeche> List_des_especes_cibles <- lieuxDePeche where(each.nom = especeCible) ;
    //ici on enleve les site de debarquement ou le pecheur ne va plus
    loop a over:LieuxPecheAEviter{
    	remove a from:List_des_especes_cibles ;
    }
    cible <- List_des_especes_cibles closest_to self;
    //le nombre de pas est aussi egale au nombre d'heur
    int nbrPas <- calculDistance() as int;
    if (nbrPas*2)<9{
    	return 300000;
    }
    if (nbrPas*2)>=9 and (nbrPas*2)<17 {
    	return 600000;
    }
    if (nbrPas*2)>=17 and (nbrPas*2)<24{
    	return 900000;
    }
    if (nbrPas*2)>=24 and (nbrPas*2) <32{
    	return 1200000;
    }
    //le pecheur peut aller jusqu a 1 mois
    
    }
    //calcul de la distance reel entre le site de debarquement et le lieu de cible
    action calculDistance{
    	/*
    	 * dakar thies en ligne droite fait 62km dans la simulation ca equivaut a 0.5782172009959085 et il fait 4 saut de speed 0.19
    	 * qui equivaut a 20km/h pour y attendre
    	 * faire la regle de 3 pour determiner la disance et et voir le nombre de temps on fonction du nombre de pas
    	 */
    	 float distanceAvecCible <- self distance_to cible;
    	 float distance <- (distanceAvecCible*62.0)/0.5782172009959085;
    	 int nbrPas <- round(distance/20);
    	 return nbrPas;
    	 
    }
    //calcul de la distance reel entre le lieu de peche et site de debarquement 
     action calculDistanceRetour(ville site){
    	/*
    	 * dakar thies en ligne droite fait 62km dans la simulation ca equivaut a 0.5782172009959085 et il fait 4 saut de speed 0.19
    	 * qui equivaut a 20km/h pour y attendre
    	 * faire la regle de 3 pour determiner la disance et et voir le nombre de temps on fonction du nombre de pas
    	 */
    	 float distanceAvecCible <- self distance_to site;
    	 float distance <- (distanceAvecCible*62.0)/0.5782172009959085;
    	 int nbrPas <- round(distance/20);
    	 return nbrPas;
    	 
    }
   }
species ville {
	
	string nom;
	float demandeMaxSardinelle <- 300.0 ;
	float demandeMaxThiof <- 200.0 ;
	float offreSardinelle <- 1.0 ;
	float offreThiof <- 1.0 ;
	//l'offre de la journee precedente
	float ancienneOffreSardinelle <- 1.0 ;
	float ancienneOffreThiof <- 0.0 ;
	bool isSiteDeDebarquement<-false;
	int nbrBateau <-0;
	float prixSardinelle;
	float prixThiof;
	
	
    aspect base {
    	//si c est un site de debarquement on affiche une image t
    	loop site from: 0 to: length(sitesDeDebarquement)-1 step: 2 { 
     	if nom = sitesDeDebarquement.contents[site]{
     		isSiteDeDebarquement <- true;
     		draw ImageSiteDeDebarquement size: 0.2;
     		draw string(nom+" "+nbrBateau+ " bateaux") color: #yellow;
     	}else{
     		//draw sphere(0.01) color: #yellow;
     	}
}         
    }
    //mise a jour du nombre de bateaux
    reflex nombre_de_bateaux{
    	list<bateau> nbr <- bateau where(each.location = self.location and self.isSiteDeDebarquement = true);
    	nbrBateau <- length(nbr);
    }  
    
    reflex prixEspececible{
    	//la valeur de l'ancienne offre est modifier dans le reflex temps
    	if isSiteDeDebarquement = true {
    		//si la l'offre est egale a zero le prix est au maximum
    		if ancienneOffreSardinelle = 0{
    			prixSardinelle <- 21000.0;
    		}
    		
    		if ancienneOffreThiof = 0{
    			prixThiof <- 21000.0;
    		}
    		// si l'offre atteint la demande la il prend la valeur minimum
    		if ancienneOffreSardinelle >= demandeMaxSardinelle{
    			prixSardinelle <- 2000.0;
    		}
    		
    		if ancienneOffreThiof >= demandeMaxThiof{
    			prixThiof <- 2000.0;
    		}
    		//si c est entre l'interalle
		    		if ancienneOffreSardinelle != demandeMaxSardinelle and ancienneOffreSardinelle !=0 {
		    		prixSardinelle <- (demandeMaxSardinelle/(beta*ancienneOffreSardinelle))-(1/beta);
		    		//si le pris depasse la fourchette autorisé
		    		if prixSardinelle > 21000{
		    			prixSardinelle <- 21000.0;
		    		}
		    		//si le pris est inferieur la fourchette autorisé
		    		if prixSardinelle < 2000{
		    			prixSardinelle <- 2000.0;
		    		}
		    		
		    		write("offre "+nom+" sardinelle "+offreSardinelle);
		    		write("prix "+nom+" sardinelle "+prixSardinelle);
		    	}
		    	if   ancienneOffreThiof != demandeMaxThiof and ancienneOffreThiof !=0{
		    		prixThiof <- (demandeMaxThiof/(beta*ancienneOffreThiof))-(1/beta);
		    		//si le pris depasse la fourchette autorisé
		    		if prixThiof > 21000{
		    			prixSardinelle <- 21000.0;
		    		}
		    		//si le pris est inferieur la fourchette autorisé
		    		if prixThiof < 2000{
		    			prixThiof <- 2000.0;
		    		}
		    	}
    		
    	}
    	
    	
    }
    
    
    
}

species bateau skills: [moving] {
	pecheur cible<- nil;
	int carburant;
	list<ville> SitesDebarquement ;
	ville site_de_debarquementActuelle<-nil;
	point dernierePosition;
	init{
		//a l'initialisation sa derniere position connu est celle du site debarquement
		dernierePosition<- location;
	}
    aspect base {
    		/*if site_de_debarquementActuelle != nil{
     		draw Imagebateau size: 0.2;
     		}*/
     		//draw Imagebateau size: 0.2;
     		if site_de_debarquementActuelle = nil{
     		draw triangle(0.15) ;
     		
     		}
    }
    //a chaque deplacement l'essence diminue
    reflex deplacement{
    	if dernierePosition != location{
    		carburant <- carburant - 1;
    		dernierePosition <- location;
    	}
    }
    
   
    
}

species lieuxDePeche{
	string nom;
	float capaciteActuelle <- 0.0;
	float capaciteTotale <- 0.0;
	float RSardinelle<-0.5;
	float RThiof <-0.1;
	//verification si les condition so propisses pour qu il naparaissent sinon je cache leur apects pour
	//qu ils soient invisible
	
	
    	
    aspect base {
    if (nom = "Sardinelle" and existSandrinelle = true ) or (nom = "Thiof" and existThiof = true ) {
    	
    		//draw string(nom+" : "+capaciteActuelle+" tonnes") color: #black;
        draw circle(0.02) color: #black;
       }
    }
    //reproduction des especes cibles dans les lieux de peche
    reflex reproduction{
    	
    	
    	if nom = "Sardinelle"{
    	capaciteActuelle <- capaciteActuelle + ((RSardinelle/(365*24))*capaciteActuelle)*(1-(capaciteActuelle/capaciteTotale));
    	
    	}
    	if nom = "Thiof"{
    	capaciteActuelle <- capaciteActuelle + ((RThiof/(365*24))*capaciteActuelle)*(1-(capaciteActuelle/capaciteTotale));
    	
    	}
    }
}



species mer{
    aspect base {
        draw shape color: #gray;
    }
}
species gambie{
    aspect base {
        draw shape color: #gray border: #black;
    }
}
species guinee{
    aspect base {
        draw shape color: #gray border: #black;
    }
}
species guinee_bissau{
    aspect base {
        draw shape color: #gray border: #black;
    }
}
species maroc{
    aspect base {
        draw shape color: #gray border: #black;
    }
}

species mauritanie{
    aspect base {
        draw shape color: #gray border: #black;
    }
}

species sahara_occidentale{
    aspect base {
        draw shape color: #gray border: #black;
    }
}


species point_profondeur_temperature{
	rgb color <- #white;
	float lon <- 0.0;
	float lat <- 0.0;
	float bathy <- 0.0;
	float SSTM1 <- 0.0;
	float SSTM2 <- 0.0;
	float SSTM3 <- 0.0;
	float SSTM4 <- 0.0;
	float SSTM5 <- 0.0;
	float SSTM6 <- 0.0;
	float SSTM7 <- 0.0;
	float SSTM8 <- 0.0;
	float SSTM9 <- 0.0;
	float SSTM10 <- 0.0;
	float SSTM11 <- 0.0;
	float SSTM12 <- 0.0;
	float temperature_actuelle<- 0.0;
	float index_mois_actuelle<- 1.0;
	
	action update_mois_actuelle {
    //on met a jour la temperature en fonction du mois
		if mois =1 {temperature_actuelle<-SSTM1;index_mois_actuelle <- float(mois);}
		if mois =2 {temperature_actuelle<-SSTM2;index_mois_actuelle <- float(mois);}
		if mois =3 {temperature_actuelle<-SSTM3;index_mois_actuelle <- float(mois);}
		if mois =4 {temperature_actuelle<-SSTM4;index_mois_actuelle <- float(mois);}
		if mois =5 {temperature_actuelle<-SSTM5;index_mois_actuelle <- float(mois);}
		if mois =6 {temperature_actuelle<-SSTM6;index_mois_actuelle <- float(mois);}
		if mois =7 {temperature_actuelle<-SSTM7;index_mois_actuelle <- float(mois);}
		if mois =8 {temperature_actuelle<-SSTM8;index_mois_actuelle <- float(mois);}
		if mois =9 {temperature_actuelle<-SSTM9;index_mois_actuelle <- float(mois);}
		if mois =10 {temperature_actuelle<-SSTM10;index_mois_actuelle <- float(mois);}
		if mois =11 {temperature_actuelle<-SSTM11;index_mois_actuelle <- float(mois);}
		if mois =12 {temperature_actuelle<-SSTM12;index_mois_actuelle <- float(mois);}
    }
    
	action adaptation_de_la_couleure_a_la_temperature
	{
		//maintenant on adapte la couleure a la temperature actuelle
		if temperature_actuelle <20 {color<-rgb(1,65,130);}
		if temperature_actuelle > 20 and temperature_actuelle <= 25 {color<-rgb(10,100,165);}
		if temperature_actuelle > 25 {color<-rgb(0,3,91);}
	}
	
	reflex adaptation_au_changement_de_mois
	{
		if index_mois_actuelle!= mois{
			do update_mois_actuelle;
			do adaptation_de_la_couleure_a_la_temperature;
		}
	}
	
	
    aspect base {
        draw square(0.15) color: color;
    }
}

experiment interface type: gui {
	parameter "Shapefile pour les zones administratives:" var: shape_file_zone_administrative category: "GIS" ;
    parameter "Shapefile pourles villes:" var: shape_file_villeSenegal category: "GIS" ;
    parameter "Sites de debarquement: " var: sitesDeDebarquement category: "file" ;
    parameter "numero du mois:" var: mois among: [1, 2 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12];
    parameter "mobilite:" var: mobilite among: [true, false];
    parameter "Nombre de pêcheurs par site:" var: nbrpecheurs ;
    parameter "Capacite de charge du lieu de pêche:" var: capaciteMaxLieuDePecheSardinelle ;
    parameter "Capacité du lieu de pêche:" var: capaciteActuelleLieuDePeche ;
   
    output {
  		display carte_et_ville_display type:opengl {
  			species mer aspect: base ;
  			species point_profondeur_temperature aspect: base ;
        	species zonesAdministratives aspect: base ;
        	species gambie  aspect: base ;
        	species guinee aspect: base ;
        	species guinee_bissau aspect: base ;
        	species maroc aspect: base ;
        	species mauritanie aspect: base ;
        	species sahara_occidentale aspect: base ;
        	species lieuxDePeche aspect: base ;
        	species pecheur aspect: base ;
        	species bateau aspect: base ;
        	species ville aspect: base ;
        	
        	
        	        	
    	}
    	
    	display Population_information refresh: every(721#cycles) {
            chart "nombre de  pecheur par site de debarquement" type: histogram size: {1,0.5} position: {0, 0} {
                data "Dakar" value: ValeurNbrPecheurDakar color: #blue;
                data " Mbour" value: ValeurNbrPecheurMbour color: #blue;
                 data "Banjul" value: ValeurNbrPecheurBanjul color: #blue;
                  data "Saint Louis" value: ValeurNbrPecheurSaintLouis color: #blue;
            }
            
           
            /*
             *
             */
             chart "evolution du volume de la thiof a dakar" type: series size: {1,0.5} position: {0, 12} {
                data "volume de la sardinelle" value: ValeurOffreThiofJourDakar color: #blue;
            }
            
            chart "evolution du volume de la thiof a mbour" type: series size: {1,0.5} position: {0, 15} {
                data "evolution du prix du thiof" value: ValeurOffreThiofJourMbour color: #blue;
            }
            chart "evolution du volume de la thiof a banjul" type: series size: {1,0.5} position: {0, 18} {
                data "evolution du prix du thiof" value: ValeurOffreThiofJourBanjul color: #blue;
            }
            chart "evolution du volume de la thiof a saint louis" type: series size: {1,0.5} position: {0, 21} {
                data "evolution du prix du thiof" value: ValeurOffreThiofJourSaintLouis color: #blue;
            }
        }
          
		 
        }
    }

