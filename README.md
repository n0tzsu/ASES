# ASES

Application permettant de passer des examens SIDES.

Couplée avec un MDM, les informaticiens pourront déployer l'application sur les tablettes et ainsi passer l'application en mode application unique.  

Il est également possible de passer des paramètres, pour faire un contrôle sur le SSID de la tablette ainsi que son niveau de batterie pour s'assurer que la tablette est opérationnelle. 
Avec Jamf, il suffit d'aller dans l'onglet "Configuration des apps" dans le déploiement d'une application afin d'insérer le dictionnaire suivant : 

![alt text](ASES/appconfig_plist.PNG)
![alt text](ASES/jamf-appconfig.PNG)

Vous avez juste à modifier les chaînes de caractères selon le SSID de vos AP et de définir un niveau de batterie entre 0 et 100.
Si la tablette a un SSID différent de celui défini ou a un niveau de batterie inférieur à la valeur indiquée, l'étudiant ne pourra pas commencer l'examen.

L'étudiant a la possibilité de régler la luminosité selon ses préférences. Il peut également changer et vérouiller la rotation de la tablette (les derniers modèles d'iPads n'ayant plus de bouton pour vérouiller la rotation)
