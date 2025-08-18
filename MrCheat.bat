@echo off
:: MrCheat - Faux installateur éducatif avec timer, textes aléatoires, effet de mouvement et animations
cls

echo Installation de MrCheat en cours...
timeout /t 2 >nul
echo Copie des fichiers...
timeout /t 2 >nul
echo Finalisation...
timeout /t 2 >nul

:: Fausse alerte Windows
set vbsAlert=%temp%\alert.vbs
echo MsgBox "ALERTE ! Votre PC a ete hacke !", 16, "Alerte Virus" > "%vbsAlert%"
cscript //nologo "%vbsAlert%"
del "%vbsAlert%"

:: Crée la page HTML
set desktop=%USERPROFILE%\Desktop
set htmlFile=%desktop%\message.html
(
echo ^<html^>
echo ^<body style="background-color:blue; display:flex; flex-direction:column; justify-content:space-between; height:100vh; margin:0; font-family:Arial;"^>
echo ^<div style="text-align:center; margin-top:30px;"^>
echo ^<div id="alerteText" style="font-size:30px; color:white; position:relative;"^>Tu t'es fait hacke. Dommage, tu dois payer 50€^</div^>
echo ^<div style="margin-top:10px; font-size:20px; color:white;"^>Timer avant suppression : ^<span id="timer"^>15:00^</span> ^<span style="font-size:25px;"^>➡</span> Si le timer atteint 0, nous supprimerons toutes vos données (mots de passe, applications…)^</div^>
echo ^<div style="margin-top:10px; font-size:18px; color:yellow;" id="warningText"^>⚠️ Vos fichiers sont en danger ! ⚠️^</div^>
echo ^</div^>
echo ^<div style="text-align:center; margin-bottom:50px;"^>
echo ^<button id="payButton" style="background-color:red; color:white; font-size:20px; padding:15px 30px; position:relative;"^>Payer 50€^</button^>
echo ^<div style="margin-top:20px; width:60%%; height:20px; border:2px solid white; margin-left:auto; margin-right:auto;"^>^
echo ^<div id="progressBar" style="width:0%%; height:100%%; background-color:lime;"^>^</div^>^
echo ^</div^>
echo ^</div^>
echo ^<script^>
// Clignotement du fond
let colors = ["blue","red"];
let i = 0;
setInterval(function(){ document.body.style.backgroundColor = colors[i % colors.length]; i++; }, 500);

// Texte changeant aléatoirement
let alertMessages = ["Erreur critique !","Votre mot de passe est visible 😱","Ou pas 😏","Fichier introuvable !","⚠️ Attention ⚠️"];
setInterval(function(){
  document.getElementById("alerteText").innerText = alertMessages[Math.floor(Math.random()*alertMessages.length)];
}, 2000);

// Texte sautillant
setInterval(function(){
  let jump = Math.sin(Date.now()/200)*5;
  document.getElementById("alerteText").style.top = jump + "px";
},50);

// Timer 15 min avec prolongation 3 fois et barre de progression
let totalTime = 15*60;
let timerSpan = document.getElementById("timer");
let prolongations = 0;
let progress = document.getElementById("progressBar");

let interval = setInterval(function(){
  let minutes = Math.floor(totalTime/60);
  let seconds = totalTime % 60;
  if(seconds < 10) seconds = "0"+seconds;
  timerSpan.innerText = minutes + ":" + seconds;

  if(totalTime <= 30 && prolongations < 3){
    totalTime += 15;
    prolongations++;
  }

  progress.style.width = ((15*60 - totalTime)/(15*60)*100) + "%%";

  if(totalTime <=0){
    clearInterval(interval);
    alert("Tu n'as pas payé heureusement car j'aurais pu ne pas te rendre tes données 😁");
    alert("Le fichier a été supprime.");
    window.close();
  }

  totalTime--;
},1000);

// Bouton rouge animé légèrement et tremble au survol
let payBtn = document.getElementById("payButton");
setInterval(function(){
  payBtn.style.left = (Math.sin(Date.now()/200)*10)+"px";
},50);
payBtn.addEventListener("mouseenter", function(){
  let scale = 1;
  let hoverInterval = setInterval(function(){
    scale = 1 + Math.sin(Date.now()/100)/20;
    payBtn.style.transform = "scale("+scale+")";
  },30);
  payBtn.addEventListener("mouseleave", function(){
    clearInterval(hoverInterval);
    payBtn.style.transform = "scale(1)";
  },{once:true});
});

payBtn.addEventListener("click", function(){
  alert("Haha, c'était gratuit ! 😁");
  setTimeout(function(){ window.close(); },10000);
});

// Déplacement léger de la fenêtre
setInterval(function(){
  window.moveBy(Math.random()*4-2, Math.random()*4-2);
}, 500);

// Texte aléatoire qui apparaît à des positions aléatoires
let randomMessages = [
  "Oh des infos bancaires 😱",
  "Sympa ton compte Fortnite 😏",
  "Bonne idée de mot de passe 😜",
  "Attention, mot de passe visible !",
  "Erreur critique !"
];

setInterval(function(){
  let msg = document.createElement("div");
  msg.innerText = randomMessages[Math.floor(Math.random()*randomMessages.length)];
  msg.style.position = "absolute";
  msg.style.color = "yellow";
  msg.style.fontSize = (10+Math.random()*20) + "px";
  msg.style.left = Math.random()*90 + "%";
  msg.style.top = Math.random()*90 + "%";
  msg.style.transform = "rotate(" + (Math.random()*60-30) + "deg)";
  document.body.appendChild(msg);
  setTimeout(function(){ msg.remove(); }, 3000);
}, 2000);

echo ^</script^>
echo ^</body^>
echo ^</html^>
) > "%htmlFile%"

:: Ouvre dans Internet Explorer
start "" iexplore.exe "%htmlFile%"

:: Supprime le fichier batch après 40 secondes
timeout /t 40 /nobreak >nul
del "%htmlFile%"
del "%~f0"
