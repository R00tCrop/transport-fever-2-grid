-- the texts of the mod in every language the game ships with
--
-- the keys are the english source strings the mod passes to the translation
-- function of the game; a language that does not list a key simply keeps the
-- english text, which is why the purely numeric labels (50 m, 25%, ...) are not
-- repeated here
function data()
  return {
    en = {
      ["Name"] = "Grid",
      ["Description"] = [[Draws a measuring grid onto the terrain and adds a "Grid" button to the bar at the bottom of the game.

The grid makes it much easier to plan a town, to keep buildings and streets aligned and to estimate distances without having to place a street first. Every n-th line is drawn wider and brighter so that cells can be counted at a glance.

The button switches the grid on and off and opens a small window in which the cell size, the colour, the opacity, the line width, the emphasised lines and the covered radius can be changed at any time. All settings are stored in the savegame.

The grid is drawn around the camera instead of covering the whole map, so the number of lines stays the same no matter how large the map is. The lines are aligned to the world origin and therefore never move while the camera is panning.

The mod is purely visual and does not touch the simulation. It can be added to and removed from an existing savegame at any time.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Grid",
      ["Switch the grid on and off and change how it looks"] = "Switch the grid on and off and change how it looks",
      ["Cell size"] = "Cell size",
      ["Cell size (m)"] = "Cell size (m)",
      ["Opacity"] = "Opacity",
      ["Line width"] = "Line width",
      ["Emphasised lines"] = "Emphasised lines",
      ["Covered radius"] = "Covered radius",
      ["Covered radius (m)"] = "Covered radius (m)",
      ["Colour"] = "Colour",
      ["Log level"] = "Log level",
      ["Thin"] = "Thin",
      ["Normal"] = "Normal",
      ["Bold"] = "Bold",
      ["Off"] = "Off",
      ["Every 5"] = "Every 5",
      ["Every 10"] = "Every 10",
      ["Every 5 lines"] = "Every 5 lines",
      ["Every 10 lines"] = "Every 10 lines",
      ["Blue"] = "Blue",
      ["White"] = "White",
      ["Amber"] = "Amber",
      ["Green"] = "Green",
      ["Errors"] = "Errors",
      ["Debug"] = "Debug",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen",
      ["How strongly the grid is drawn on top of the terrain"] = "How strongly the grid is drawn on top of the terrain",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Every n-th line is drawn wider and brighter, which makes it much easier to count cells",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii",
      ["Colour of the grid lines"] = "Colour of the grid lines",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing",
    },
    de = {
      ["Name"] = "Raster",
      ["Description"] = [[Zeichnet ein Messraster auf das Gelände und fügt der Leiste am unteren Bildschirmrand eine Schaltfläche "Raster" hinzu.

Das Raster macht es viel einfacher, eine Stadt zu planen, Gebäude und Straßen auszurichten und Entfernungen abzuschätzen, ohne erst eine Straße bauen zu müssen. Jede n-te Linie wird breiter und heller gezeichnet, sodass sich Zellen auf einen Blick zählen lassen.

Die Schaltfläche schaltet das Raster ein und aus und öffnet ein kleines Fenster, in dem Zellengröße, Farbe, Deckkraft, Linienbreite, betonte Linien und der abgedeckte Radius jederzeit geändert werden können. Alle Einstellungen werden im Spielstand gespeichert.

Das Raster wird um die Kamera herum gezeichnet, statt die ganze Karte abzudecken. Die Anzahl der Linien bleibt daher gleich, egal wie groß die Karte ist. Die Linien sind am Weltursprung ausgerichtet und wandern deshalb nicht mit, wenn die Kamera bewegt wird.

Die Mod ist rein optisch und greift nicht in die Simulation ein. Sie kann jederzeit zu einem bestehenden Spielstand hinzugefügt und wieder entfernt werden.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Raster",
      ["Switch the grid on and off and change how it looks"] = "Das Raster ein- und ausschalten und sein Aussehen ändern",
      ["Cell size"] = "Zellengröße",
      ["Cell size (m)"] = "Zellengröße (m)",
      ["Opacity"] = "Deckkraft",
      ["Line width"] = "Linienbreite",
      ["Emphasised lines"] = "Betonte Linien",
      ["Covered radius"] = "Abgedeckter Radius",
      ["Covered radius (m)"] = "Abgedeckter Radius (m)",
      ["Colour"] = "Farbe",
      ["Log level"] = "Protokollstufe",
      ["Thin"] = "Dünn",
      ["Normal"] = "Normal",
      ["Bold"] = "Dick",
      ["Off"] = "Aus",
      ["Every 5"] = "Alle 5",
      ["Every 10"] = "Alle 10",
      ["Every 5 lines"] = "Alle 5 Linien",
      ["Every 10 lines"] = "Alle 10 Linien",
      ["Blue"] = "Blau",
      ["White"] = "Weiß",
      ["Amber"] = "Bernstein",
      ["Green"] = "Grün",
      ["Errors"] = "Fehler",
      ["Debug"] = "Debug",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Größe einer Rasterzelle beim Start eines Spiels; sie lässt sich jederzeit über die Raster-Schaltfläche am unteren Bildschirmrand ändern",
      ["How strongly the grid is drawn on top of the terrain"] = "Wie stark das Raster über dem Gelände gezeichnet wird",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Breite der Rasterlinien; breitere Linien bleiben ruhig, wenn die Kamera weit herausgezoomt ist, schmalere können anfangen zu flimmern",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Jede n-te Linie wird breiter und heller gezeichnet, wodurch sich Zellen viel leichter zählen lassen",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Wie weit das Raster um die Kamera reicht; ein größerer Radius kostet mehr Leistung, und eine kleine Zellengröße erreicht die größten Radien nicht",
      ["Colour of the grid lines"] = "Farbe der Rasterlinien",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Fehler werden in das Spielprotokoll geschrieben; Debug zeigt zusätzlich eine Anzeige im Spiel, die verrät, was die Mod gerade tut",
    },
    es = {
      ["Name"] = "Cuadrícula",
      ["Description"] = [[Dibuja una cuadrícula de medición sobre el terreno y añade un botón "Cuadrícula" a la barra inferior del juego.

La cuadrícula facilita mucho planificar una ciudad, alinear edificios y calles y estimar distancias sin tener que construir una calle primero. Cada n-ésima línea se dibuja más gruesa y brillante para poder contar las celdas de un vistazo.

El botón activa y desactiva la cuadrícula y abre una pequeña ventana en la que se pueden cambiar en cualquier momento el tamaño de celda, el color, la opacidad, el grosor de línea, las líneas destacadas y el radio cubierto. Todos los ajustes se guardan en la partida.

La cuadrícula se dibuja alrededor de la cámara en lugar de cubrir todo el mapa, por lo que el número de líneas no cambia por grande que sea el mapa. Las líneas están alineadas con el origen del mundo, así que nunca se mueven mientras se desplaza la cámara.

El mod es puramente visual y no toca la simulación. Se puede añadir y quitar de una partida guardada en cualquier momento.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Cuadrícula",
      ["Switch the grid on and off and change how it looks"] = "Activa y desactiva la cuadrícula y cambia su aspecto",
      ["Cell size"] = "Tamaño de celda",
      ["Cell size (m)"] = "Tamaño de celda (m)",
      ["Opacity"] = "Opacidad",
      ["Line width"] = "Grosor de línea",
      ["Emphasised lines"] = "Líneas destacadas",
      ["Covered radius"] = "Radio cubierto",
      ["Covered radius (m)"] = "Radio cubierto (m)",
      ["Colour"] = "Color",
      ["Log level"] = "Nivel de registro",
      ["Thin"] = "Fina",
      ["Normal"] = "Normal",
      ["Bold"] = "Gruesa",
      ["Off"] = "Desactivado",
      ["Every 5"] = "Cada 5",
      ["Every 10"] = "Cada 10",
      ["Every 5 lines"] = "Cada 5 líneas",
      ["Every 10 lines"] = "Cada 10 líneas",
      ["Blue"] = "Azul",
      ["White"] = "Blanco",
      ["Amber"] = "Ámbar",
      ["Green"] = "Verde",
      ["Errors"] = "Errores",
      ["Debug"] = "Depuración",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Tamaño de una celda al empezar una partida; se puede cambiar en cualquier momento con el botón de la cuadrícula en la parte inferior de la pantalla",
      ["How strongly the grid is drawn on top of the terrain"] = "Con qué intensidad se dibuja la cuadrícula sobre el terreno",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Grosor de las líneas; las líneas más gruesas se mantienen estables al alejar la cámara, las más finas pueden parpadear",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Cada n-ésima línea se dibuja más gruesa y brillante, lo que facilita mucho contar las celdas",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Hasta dónde llega la cuadrícula alrededor de la cámara; un radio mayor cuesta más rendimiento y un tamaño de celda pequeño no alcanza los radios mayores",
      ["Colour of the grid lines"] = "Color de las líneas de la cuadrícula",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Los errores se escriben en el registro del juego; depuración muestra además un panel en el juego que indica qué está haciendo el mod",
    },
    fr = {
      ["Name"] = "Grille",
      ["Description"] = [[Dessine une grille de mesure sur le terrain et ajoute un bouton « Grille » à la barre en bas de l’écran.

La grille facilite grandement la planification d’une ville, l’alignement des bâtiments et des rues ainsi que l’estimation des distances sans avoir à poser une route au préalable. Une ligne sur n est dessinée plus épaisse et plus lumineuse afin de compter les cellules d’un coup d’œil.

Le bouton active et désactive la grille et ouvre une petite fenêtre où la taille des cellules, la couleur, l’opacité, l’épaisseur des lignes, les lignes accentuées et le rayon couvert peuvent être modifiés à tout moment. Tous les réglages sont enregistrés dans la sauvegarde.

La grille est dessinée autour de la caméra au lieu de couvrir toute la carte : le nombre de lignes reste donc le même quelle que soit la taille de la carte. Les lignes sont alignées sur l’origine du monde et ne bougent donc jamais lorsque la caméra se déplace.

Le mod est purement visuel et ne touche pas à la simulation. Il peut être ajouté à une sauvegarde existante et retiré à tout moment.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Grille",
      ["Switch the grid on and off and change how it looks"] = "Activer ou désactiver la grille et modifier son apparence",
      ["Cell size"] = "Taille des cellules",
      ["Cell size (m)"] = "Taille des cellules (m)",
      ["Opacity"] = "Opacité",
      ["Line width"] = "Épaisseur des lignes",
      ["Emphasised lines"] = "Lignes accentuées",
      ["Covered radius"] = "Rayon couvert",
      ["Covered radius (m)"] = "Rayon couvert (m)",
      ["Colour"] = "Couleur",
      ["Log level"] = "Niveau de journal",
      ["Thin"] = "Fine",
      ["Normal"] = "Normale",
      ["Bold"] = "Épaisse",
      ["Off"] = "Désactivé",
      ["Every 5"] = "Toutes les 5",
      ["Every 10"] = "Toutes les 10",
      ["Every 5 lines"] = "Toutes les 5 lignes",
      ["Every 10 lines"] = "Toutes les 10 lignes",
      ["Blue"] = "Bleu",
      ["White"] = "Blanc",
      ["Amber"] = "Ambre",
      ["Green"] = "Vert",
      ["Errors"] = "Erreurs",
      ["Debug"] = "Débogage",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Taille d’une cellule au démarrage d’une partie ; elle peut être modifiée à tout moment avec le bouton de la grille en bas de l’écran",
      ["How strongly the grid is drawn on top of the terrain"] = "Intensité avec laquelle la grille est dessinée sur le terrain",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Épaisseur des lignes ; les lignes plus épaisses restent stables lorsque la caméra est très éloignée, les plus fines peuvent scintiller",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Une ligne sur n est dessinée plus épaisse et plus lumineuse, ce qui facilite grandement le comptage des cellules",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Distance couverte par la grille autour de la caméra ; un rayon plus grand coûte plus de performances et une petite taille de cellule n’atteint pas les plus grands rayons",
      ["Colour of the grid lines"] = "Couleur des lignes de la grille",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Les erreurs sont écrites dans le journal du jeu ; le débogage affiche en plus un panneau en jeu indiquant ce que fait le mod",
    },
    it = {
      ["Name"] = "Griglia",
      ["Description"] = [[Disegna una griglia di misurazione sul terreno e aggiunge un pulsante "Griglia" alla barra in fondo allo schermo.

La griglia rende molto più semplice pianificare una città, allineare edifici e strade e stimare le distanze senza dover prima costruire una strada. Ogni n-esima linea viene disegnata più spessa e più chiara, così le celle si contano a colpo d’occhio.

Il pulsante attiva e disattiva la griglia e apre una piccola finestra in cui dimensione delle celle, colore, opacità, spessore delle linee, linee evidenziate e raggio coperto possono essere cambiati in qualsiasi momento. Tutte le impostazioni vengono salvate nella partita.

La griglia viene disegnata intorno alla telecamera invece di coprire l’intera mappa, quindi il numero di linee resta lo stesso indipendentemente dalle dimensioni della mappa. Le linee sono allineate all’origine del mondo e non si spostano mai mentre la telecamera si muove.

La mod è puramente visiva e non tocca la simulazione. Può essere aggiunta a una partita salvata e rimossa in qualsiasi momento.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Griglia",
      ["Switch the grid on and off and change how it looks"] = "Attiva e disattiva la griglia e ne cambia l’aspetto",
      ["Cell size"] = "Dimensione celle",
      ["Cell size (m)"] = "Dimensione celle (m)",
      ["Opacity"] = "Opacità",
      ["Line width"] = "Spessore linee",
      ["Emphasised lines"] = "Linee evidenziate",
      ["Covered radius"] = "Raggio coperto",
      ["Covered radius (m)"] = "Raggio coperto (m)",
      ["Colour"] = "Colore",
      ["Log level"] = "Livello di log",
      ["Thin"] = "Sottile",
      ["Normal"] = "Normale",
      ["Bold"] = "Spessa",
      ["Off"] = "Disattivato",
      ["Every 5"] = "Ogni 5",
      ["Every 10"] = "Ogni 10",
      ["Every 5 lines"] = "Ogni 5 linee",
      ["Every 10 lines"] = "Ogni 10 linee",
      ["Blue"] = "Blu",
      ["White"] = "Bianco",
      ["Amber"] = "Ambra",
      ["Green"] = "Verde",
      ["Errors"] = "Errori",
      ["Debug"] = "Debug",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Dimensione di una cella all’avvio di una partita; può essere cambiata in qualsiasi momento con il pulsante della griglia in fondo allo schermo",
      ["How strongly the grid is drawn on top of the terrain"] = "Quanto intensamente la griglia viene disegnata sul terreno",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Spessore delle linee; le linee più spesse restano stabili con la telecamera molto lontana, quelle più sottili possono tremolare",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Ogni n-esima linea viene disegnata più spessa e più chiara, il che rende molto più facile contare le celle",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Fin dove arriva la griglia intorno alla telecamera; un raggio maggiore costa più prestazioni e una cella piccola non raggiunge i raggi più grandi",
      ["Colour of the grid lines"] = "Colore delle linee della griglia",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Gli errori vengono scritti nel log del gioco; il debug mostra inoltre un pannello in gioco che indica cosa sta facendo la mod",
    },
    ja = {
      ["Name"] = "グリッド",
      ["Description"] = [[地形の上に計測用のグリッドを描画し、画面下部のバーに「グリッド」ボタンを追加します。

グリッドがあると、街の計画、建物や道路の位置合わせ、距離の見積もりが格段に楽になります。道路を仮に敷いてみる必要はありません。n本ごとに線を太く明るく描くため、セル数もひと目で数えられます。

ボタンでグリッドの表示を切り替えると同時に小さなウィンドウが開き、セルサイズ、色、不透明度、線の太さ、強調線、表示範囲をいつでも変更できます。設定はセーブデータに保存されます。

グリッドはマップ全体ではなくカメラの周囲に描かれるため、マップがどれだけ大きくても線の数は変わりません。線はワールド原点を基準に配置されるので、カメラを動かしても線が動くことはありません。

この MOD は見た目だけのもので、シミュレーションには一切干渉しません。既存のセーブデータにいつでも追加・削除できます。

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "グリッド",
      ["Switch the grid on and off and change how it looks"] = "グリッドの表示を切り替え、見た目を変更します",
      ["Cell size"] = "セルサイズ",
      ["Cell size (m)"] = "セルサイズ (m)",
      ["Opacity"] = "不透明度",
      ["Line width"] = "線の太さ",
      ["Emphasised lines"] = "強調線",
      ["Covered radius"] = "表示範囲",
      ["Covered radius (m)"] = "表示範囲 (m)",
      ["Colour"] = "色",
      ["Log level"] = "ログレベル",
      ["Thin"] = "細い",
      ["Normal"] = "標準",
      ["Bold"] = "太い",
      ["Off"] = "オフ",
      ["Every 5"] = "5本ごと",
      ["Every 10"] = "10本ごと",
      ["Every 5 lines"] = "5本ごと",
      ["Every 10 lines"] = "10本ごと",
      ["Blue"] = "青",
      ["White"] = "白",
      ["Amber"] = "琥珀色",
      ["Green"] = "緑",
      ["Errors"] = "エラー",
      ["Debug"] = "デバッグ",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "ゲーム開始時のセルサイズです。画面下部のグリッドボタンでいつでも変更できます",
      ["How strongly the grid is drawn on top of the terrain"] = "グリッドを地形の上にどれだけ濃く描くか",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "グリッド線の太さです。太い線はカメラを大きく引いても安定しますが、細い線はちらつくことがあります",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "n本ごとに線を太く明るく描き、セルを数えやすくします",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "カメラの周囲にグリッドが広がる範囲です。範囲が広いほど負荷が高く、セルが小さいと最大範囲には届きません",
      ["Colour of the grid lines"] = "グリッド線の色",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "エラーはゲームのログに記録されます。デバッグではさらに、MODの動作を示すパネルをゲーム内に表示します",
    },
    ko = {
      ["Name"] = "격자",
      ["Description"] = [[지형 위에 측정용 격자를 그리고, 화면 아래쪽 바에 "격자" 버튼을 추가합니다.

격자가 있으면 도시를 계획하고, 건물과 도로를 정렬하고, 도로를 먼저 놓아 보지 않고도 거리를 가늠하기가 훨씬 쉬워집니다. n번째 선마다 더 굵고 밝게 그려지므로 칸 수도 한눈에 셀 수 있습니다.

버튼을 누르면 격자가 켜지고 꺼지며, 칸 크기, 색상, 불투명도, 선 굵기, 강조선, 표시 반경을 언제든지 바꿀 수 있는 작은 창이 함께 열립니다. 모든 설정은 저장 파일에 보관됩니다.

격자는 지도 전체가 아니라 카메라 주위에만 그려지므로, 지도가 아무리 커도 선의 개수는 그대로입니다. 선은 월드 원점을 기준으로 배치되어 카메라를 움직여도 흔들리지 않습니다.

이 모드는 순수하게 시각적이며 시뮬레이션에는 전혀 관여하지 않습니다. 기존 저장 파일에 언제든지 추가하고 제거할 수 있습니다.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "격자",
      ["Switch the grid on and off and change how it looks"] = "격자를 켜고 끄며 모양을 변경합니다",
      ["Cell size"] = "칸 크기",
      ["Cell size (m)"] = "칸 크기 (m)",
      ["Opacity"] = "불투명도",
      ["Line width"] = "선 굵기",
      ["Emphasised lines"] = "강조선",
      ["Covered radius"] = "표시 반경",
      ["Covered radius (m)"] = "표시 반경 (m)",
      ["Colour"] = "색상",
      ["Log level"] = "로그 수준",
      ["Thin"] = "얇게",
      ["Normal"] = "보통",
      ["Bold"] = "굵게",
      ["Off"] = "끄기",
      ["Every 5"] = "5칸마다",
      ["Every 10"] = "10칸마다",
      ["Every 5 lines"] = "5칸마다",
      ["Every 10 lines"] = "10칸마다",
      ["Blue"] = "파랑",
      ["White"] = "흰색",
      ["Amber"] = "호박색",
      ["Green"] = "초록",
      ["Errors"] = "오류",
      ["Debug"] = "디버그",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "게임을 시작할 때의 칸 크기입니다. 화면 아래쪽의 격자 버튼으로 언제든지 변경할 수 있습니다",
      ["How strongly the grid is drawn on top of the terrain"] = "지형 위에 격자를 얼마나 진하게 그릴지 정합니다",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "격자선의 굵기입니다. 굵은 선은 카메라를 멀리 당겨도 안정적이지만, 얇은 선은 깜빡일 수 있습니다",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "n번째 선마다 더 굵고 밝게 그려 칸을 세기 쉽게 합니다",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "카메라 주위로 격자가 미치는 범위입니다. 반경이 클수록 성능 부담이 크고, 칸이 작으면 가장 큰 반경에는 도달하지 못합니다",
      ["Colour of the grid lines"] = "격자선의 색상",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "오류는 게임 로그에 기록됩니다. 디버그를 선택하면 모드의 동작을 알려주는 패널이 게임 안에 추가로 표시됩니다",
    },
    nl = {
      ["Name"] = "Raster",
      ["Description"] = [[Tekent een meetraster op het terrein en voegt een knop "Raster" toe aan de balk onderaan het scherm.

Het raster maakt het veel eenvoudiger om een stad te plannen, gebouwen en straten uit te lijnen en afstanden in te schatten zonder eerst een weg te moeten aanleggen. Elke n-de lijn wordt breder en helderder getekend, zodat cellen in één oogopslag te tellen zijn.

De knop schakelt het raster in en uit en opent een klein venster waarin celgrootte, kleur, dekking, lijndikte, benadrukte lijnen en de bedekte straal op elk moment kunnen worden aangepast. Alle instellingen worden in het opgeslagen spel bewaard.

Het raster wordt rond de camera getekend in plaats van de hele kaart te bedekken, waardoor het aantal lijnen gelijk blijft, hoe groot de kaart ook is. De lijnen zijn uitgelijnd op de oorsprong van de wereld en bewegen dus nooit mee terwijl de camera verschuift.

De mod is puur visueel en raakt de simulatie niet aan. Hij kan op elk moment aan een bestaand opgeslagen spel worden toegevoegd en er weer uit worden verwijderd.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Raster",
      ["Switch the grid on and off and change how it looks"] = "Het raster in- en uitschakelen en het uiterlijk aanpassen",
      ["Cell size"] = "Celgrootte",
      ["Cell size (m)"] = "Celgrootte (m)",
      ["Opacity"] = "Dekking",
      ["Line width"] = "Lijndikte",
      ["Emphasised lines"] = "Benadrukte lijnen",
      ["Covered radius"] = "Bedekte straal",
      ["Covered radius (m)"] = "Bedekte straal (m)",
      ["Colour"] = "Kleur",
      ["Log level"] = "Logniveau",
      ["Thin"] = "Dun",
      ["Normal"] = "Normaal",
      ["Bold"] = "Dik",
      ["Off"] = "Uit",
      ["Every 5"] = "Elke 5",
      ["Every 10"] = "Elke 10",
      ["Every 5 lines"] = "Elke 5 lijnen",
      ["Every 10 lines"] = "Elke 10 lijnen",
      ["Blue"] = "Blauw",
      ["White"] = "Wit",
      ["Amber"] = "Amber",
      ["Green"] = "Groen",
      ["Errors"] = "Fouten",
      ["Debug"] = "Debug",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Grootte van een rastercel bij het starten van een spel; deze kan altijd worden aangepast met de rasterknop onderaan het scherm",
      ["How strongly the grid is drawn on top of the terrain"] = "Hoe sterk het raster over het terrein wordt getekend",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Breedte van de rasterlijnen; bredere lijnen blijven rustig als de camera ver uitgezoomd is, dunnere kunnen gaan flikkeren",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Elke n-de lijn wordt breder en helderder getekend, waardoor cellen veel makkelijker te tellen zijn",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Hoe ver het raster rond de camera reikt; een grotere straal kost meer prestaties en een kleine celgrootte haalt de grootste stralen niet",
      ["Colour of the grid lines"] = "Kleur van de rasterlijnen",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Fouten worden naar het spellogboek geschreven; debug toont daarnaast een paneel in het spel dat vertelt wat de mod doet",
    },
    pl = {
      ["Name"] = "Siatka",
      ["Description"] = [[Rysuje siatkę pomiarową na terenie i dodaje przycisk "Siatka" do paska na dole ekranu.

Siatka znacznie ułatwia planowanie miasta, wyrównywanie budynków i ulic oraz szacowanie odległości bez konieczności stawiania najpierw drogi. Co n-ta linia jest rysowana grubiej i jaśniej, dzięki czemu komórki można policzyć jednym spojrzeniem.

Przycisk włącza i wyłącza siatkę oraz otwiera małe okno, w którym w dowolnej chwili można zmienić rozmiar komórki, kolor, krycie, grubość linii, wyróżnione linie i zasięg siatki. Wszystkie ustawienia są zapisywane w stanie gry.

Siatka jest rysowana wokół kamery zamiast pokrywać całą mapę, więc liczba linii pozostaje taka sama niezależnie od jej wielkości. Linie są wyrównane do początku układu świata, dlatego nigdy nie przesuwają się podczas ruchu kamery.

Modyfikacja jest czysto wizualna i nie ingeruje w symulację. Można ją w dowolnym momencie dodać do istniejącego zapisu i z niego usunąć.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Siatka",
      ["Switch the grid on and off and change how it looks"] = "Włącza i wyłącza siatkę oraz zmienia jej wygląd",
      ["Cell size"] = "Rozmiar komórki",
      ["Cell size (m)"] = "Rozmiar komórki (m)",
      ["Opacity"] = "Krycie",
      ["Line width"] = "Grubość linii",
      ["Emphasised lines"] = "Wyróżnione linie",
      ["Covered radius"] = "Zasięg siatki",
      ["Covered radius (m)"] = "Zasięg siatki (m)",
      ["Colour"] = "Kolor",
      ["Log level"] = "Poziom logowania",
      ["Thin"] = "Cienka",
      ["Normal"] = "Normalna",
      ["Bold"] = "Gruba",
      ["Off"] = "Wyłączone",
      ["Every 5"] = "Co 5",
      ["Every 10"] = "Co 10",
      ["Every 5 lines"] = "Co 5 linii",
      ["Every 10 lines"] = "Co 10 linii",
      ["Blue"] = "Niebieski",
      ["White"] = "Biały",
      ["Amber"] = "Bursztynowy",
      ["Green"] = "Zielony",
      ["Errors"] = "Błędy",
      ["Debug"] = "Debugowanie",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Rozmiar komórki siatki na początku gry; można go zmienić w dowolnej chwili przyciskiem siatki na dole ekranu",
      ["How strongly the grid is drawn on top of the terrain"] = "Jak mocno siatka jest rysowana na terenie",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Grubość linii siatki; grubsze linie pozostają spokojne przy oddalonej kamerze, cieńsze mogą migotać",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Co n-ta linia jest rysowana grubiej i jaśniej, co znacznie ułatwia liczenie komórek",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Jak daleko siatka sięga wokół kamery; większy zasięg kosztuje więcej wydajności, a mała komórka nie osiągnie największych zasięgów",
      ["Colour of the grid lines"] = "Kolor linii siatki",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Błędy są zapisywane w dzienniku gry; debugowanie dodatkowo pokazuje w grze panel informujący, co robi modyfikacja",
    },
    pt_BR = {
      ["Name"] = "Grade",
      ["Description"] = [[Desenha uma grade de medição sobre o terreno e adiciona um botão "Grade" à barra na parte inferior do jogo.

A grade facilita muito planejar uma cidade, alinhar prédios e ruas e estimar distâncias sem precisar construir uma rua antes. A cada n-ésima linha o traço é mais grosso e mais claro, de modo que as células podem ser contadas num relance.

O botão liga e desliga a grade e abre uma pequena janela na qual o tamanho da célula, a cor, a opacidade, a espessura da linha, as linhas destacadas e o raio coberto podem ser alterados a qualquer momento. Todas as configurações são salvas no jogo salvo.

A grade é desenhada ao redor da câmera em vez de cobrir o mapa inteiro, então o número de linhas permanece o mesmo por maior que seja o mapa. As linhas são alinhadas à origem do mundo e, por isso, nunca se movem enquanto a câmera se desloca.

O mod é puramente visual e não interfere na simulação. Pode ser adicionado a um jogo salvo existente e removido a qualquer momento.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Grade",
      ["Switch the grid on and off and change how it looks"] = "Liga e desliga a grade e altera sua aparência",
      ["Cell size"] = "Tamanho da célula",
      ["Cell size (m)"] = "Tamanho da célula (m)",
      ["Opacity"] = "Opacidade",
      ["Line width"] = "Espessura da linha",
      ["Emphasised lines"] = "Linhas destacadas",
      ["Covered radius"] = "Raio coberto",
      ["Covered radius (m)"] = "Raio coberto (m)",
      ["Colour"] = "Cor",
      ["Log level"] = "Nível de log",
      ["Thin"] = "Fina",
      ["Normal"] = "Normal",
      ["Bold"] = "Grossa",
      ["Off"] = "Desligado",
      ["Every 5"] = "A cada 5",
      ["Every 10"] = "A cada 10",
      ["Every 5 lines"] = "A cada 5 linhas",
      ["Every 10 lines"] = "A cada 10 linhas",
      ["Blue"] = "Azul",
      ["White"] = "Branco",
      ["Amber"] = "Âmbar",
      ["Green"] = "Verde",
      ["Errors"] = "Erros",
      ["Debug"] = "Depuração",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Tamanho de uma célula ao iniciar um jogo; pode ser alterado a qualquer momento com o botão da grade na parte inferior da tela",
      ["How strongly the grid is drawn on top of the terrain"] = "Com que intensidade a grade é desenhada sobre o terreno",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Espessura das linhas da grade; linhas mais grossas permanecem estáveis com a câmera bem afastada, as mais finas podem tremular",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "A cada n-ésima linha é desenhada mais grossa e mais clara, o que facilita muito a contagem das células",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Até onde a grade alcança ao redor da câmera; um raio maior custa mais desempenho e uma célula pequena não alcança os maiores raios",
      ["Colour of the grid lines"] = "Cor das linhas da grade",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Os erros são gravados no log do jogo; a depuração mostra ainda um painel no jogo que informa o que o mod está fazendo",
    },
    ru = {
      ["Name"] = "Сетка",
      ["Description"] = [[Рисует измерительную сетку прямо на ландшафте и добавляет кнопку «Сетка» в нижнюю панель игры.

С сеткой намного проще планировать город, выравнивать здания и улицы и прикидывать расстояния, не строя для этого пробную дорогу. Каждая n-я линия рисуется шире и ярче, поэтому ячейки легко пересчитать одним взглядом.

Кнопка включает и выключает сетку и открывает небольшое окно, в котором в любой момент можно изменить размер ячейки, цвет, непрозрачность, толщину линий, выделенные линии и радиус покрытия. Все настройки хранятся в сохранённой игре.

Сетка рисуется вокруг камеры, а не покрывает всю карту, поэтому число линий не зависит от размера карты. Линии привязаны к началу координат мира и не смещаются, когда камера движется.

Мод чисто визуальный и не вмешивается в симуляцию. Его можно в любой момент добавить в существующее сохранение и убрать обратно.

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "Сетка",
      ["Switch the grid on and off and change how it looks"] = "Включить или выключить сетку и изменить её вид",
      ["Cell size"] = "Размер ячейки",
      ["Cell size (m)"] = "Размер ячейки (м)",
      ["Opacity"] = "Непрозрачность",
      ["Line width"] = "Толщина линий",
      ["Emphasised lines"] = "Выделенные линии",
      ["Covered radius"] = "Радиус покрытия",
      ["Covered radius (m)"] = "Радиус покрытия (м)",
      ["Colour"] = "Цвет",
      ["Log level"] = "Уровень журнала",
      ["Thin"] = "Тонкие",
      ["Normal"] = "Обычные",
      ["Bold"] = "Жирные",
      ["Off"] = "Выкл.",
      ["Every 5"] = "Каждая 5-я",
      ["Every 10"] = "Каждая 10-я",
      ["Every 5 lines"] = "Каждая 5-я линия",
      ["Every 10 lines"] = "Каждая 10-я линия",
      ["Blue"] = "Синий",
      ["White"] = "Белый",
      ["Amber"] = "Янтарный",
      ["Green"] = "Зелёный",
      ["Errors"] = "Ошибки",
      ["Debug"] = "Отладка",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "Размер ячейки сетки в начале игры; его можно изменить в любой момент кнопкой сетки внизу экрана",
      ["How strongly the grid is drawn on top of the terrain"] = "Насколько ярко сетка рисуется поверх ландшафта",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "Толщина линий сетки; более широкие линии остаются спокойными при сильном отдалении камеры, тонкие могут мерцать",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "Каждая n-я линия рисуется шире и ярче, благодаря чему ячейки гораздо легче считать",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "Насколько далеко сетка простирается вокруг камеры; больший радиус нагружает сильнее, а с маленькой ячейкой самые большие радиусы недостижимы",
      ["Colour of the grid lines"] = "Цвет линий сетки",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "Ошибки записываются в журнал игры; отладка дополнительно показывает в игре панель, которая сообщает, что делает мод",
    },
    zh_CN = {
      ["Name"] = "网格",
      ["Description"] = [[在地形上绘制测量网格，并在游戏底部的信息栏中添加一个"网格"按钮。

有了网格，规划城镇、对齐建筑与道路、估算距离都会轻松许多，不必先修一条路来量距离。每隔 n 条线会绘制得更粗更亮，一眼就能数清格子。

按钮用于开关网格，同时打开一个小窗口，可随时调整单元格大小、颜色、不透明度、线宽、加粗线和覆盖半径。所有设置都会保存在存档中。

网格只绘制在镜头周围，而不是铺满整张地图，因此无论地图多大，线条数量都保持不变。线条以世界原点对齐，镜头移动时不会跟着晃动。

本模组纯粹是视觉效果，不会影响模拟。可随时加入已有存档，也可随时移除。

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "网格",
      ["Switch the grid on and off and change how it looks"] = "开关网格并调整其外观",
      ["Cell size"] = "单元格大小",
      ["Cell size (m)"] = "单元格大小 (m)",
      ["Opacity"] = "不透明度",
      ["Line width"] = "线宽",
      ["Emphasised lines"] = "加粗线",
      ["Covered radius"] = "覆盖半径",
      ["Covered radius (m)"] = "覆盖半径 (m)",
      ["Colour"] = "颜色",
      ["Log level"] = "日志级别",
      ["Thin"] = "细",
      ["Normal"] = "标准",
      ["Bold"] = "粗",
      ["Off"] = "关闭",
      ["Every 5"] = "每5条",
      ["Every 10"] = "每10条",
      ["Every 5 lines"] = "每5条线",
      ["Every 10 lines"] = "每10条线",
      ["Blue"] = "蓝色",
      ["White"] = "白色",
      ["Amber"] = "琥珀色",
      ["Green"] = "绿色",
      ["Errors"] = "错误",
      ["Debug"] = "调试",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "开始游戏时的单元格大小，随时可通过屏幕底部的网格按钮修改",
      ["How strongly the grid is drawn on top of the terrain"] = "网格绘制在地形上的浓淡程度",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "网格线的宽度。较宽的线在镜头拉远时依然稳定，较细的线可能会闪烁",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "每隔 n 条线绘制得更粗更亮，便于数格子",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "网格在镜头周围延伸的范围。半径越大性能开销越高，单元格过小则无法达到最大半径",
      ["Colour of the grid lines"] = "网格线的颜色",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "错误会写入游戏日志；调试模式还会在游戏中显示一个面板，说明模组正在做什么",
    },
    zh_TW = {
      ["Name"] = "網格",
      ["Description"] = [[在地形上繪製測量網格，並在遊戲底部的資訊列中加入一個「網格」按鈕。

有了網格，規劃城鎮、對齊建築與道路、估算距離都會輕鬆許多，不必先蓋一條路來量距離。每隔 n 條線會繪製得更粗更亮，一眼就能數清格子。

按鈕用於開關網格，同時開啟一個小視窗，可隨時調整格子大小、顏色、不透明度、線寬、加粗線和覆蓋半徑。所有設定都會儲存在存檔中。

網格只繪製在鏡頭周圍，而不是鋪滿整張地圖，因此無論地圖多大，線條數量都保持不變。線條以世界原點對齊，鏡頭移動時不會跟著晃動。

本模組純粹是視覺效果，不會影響模擬。可隨時加入既有存檔，也可隨時移除。

Repository: https://github.com/R00tCrop/transport-fever-2-grid
Licence: MIT
Written with Claude Opus 5 by Anthropic.]],
      ["Grid"] = "網格",
      ["Switch the grid on and off and change how it looks"] = "開關網格並調整其外觀",
      ["Cell size"] = "格子大小",
      ["Cell size (m)"] = "格子大小 (m)",
      ["Opacity"] = "不透明度",
      ["Line width"] = "線寬",
      ["Emphasised lines"] = "加粗線",
      ["Covered radius"] = "覆蓋半徑",
      ["Covered radius (m)"] = "覆蓋半徑 (m)",
      ["Colour"] = "顏色",
      ["Log level"] = "日誌等級",
      ["Thin"] = "細",
      ["Normal"] = "標準",
      ["Bold"] = "粗",
      ["Off"] = "關閉",
      ["Every 5"] = "每5條",
      ["Every 10"] = "每10條",
      ["Every 5 lines"] = "每5條線",
      ["Every 10 lines"] = "每10條線",
      ["Blue"] = "藍色",
      ["White"] = "白色",
      ["Amber"] = "琥珀色",
      ["Green"] = "綠色",
      ["Errors"] = "錯誤",
      ["Debug"] = "偵錯",
      ["Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen"] = "開始遊戲時的格子大小，隨時可透過畫面底部的網格按鈕修改",
      ["How strongly the grid is drawn on top of the terrain"] = "網格繪製在地形上的濃淡程度",
      ["Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer"] = "網格線的寬度。較寬的線在鏡頭拉遠時依然穩定，較細的線可能會閃爍",
      ["Every n-th line is drawn wider and brighter, which makes it much easier to count cells"] = "每隔 n 條線繪製得更粗更亮，便於數格子",
      ["How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii"] = "網格在鏡頭周圍延伸的範圍。半徑越大效能開銷越高，格子過小則無法達到最大半徑",
      ["Colour of the grid lines"] = "網格線的顏色",
      ["Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing"] = "錯誤會寫入遊戲日誌；偵錯模式還會在遊戲中顯示一個面板，說明模組正在做什麼",
    },
  }
end
