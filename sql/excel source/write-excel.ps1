$excel=new-object -com excel.application
$excel.visible = $true

$book = $excel.Workbooks.Add()
$sheet = $book.Worksheets.Item(1)

#on ecrit dans les 3 cellules
$sheet.Cells.Item(1,1) = "bonjour"
$sheet.Cells.Item(1,2) = "le"
$sheet.Cells.Item(1,3) = "monde"

#police pour une case
$sheet.Cells.Item(1,1).font.bold = $true 
$sheet.Cells.Item(1,2).font.size = 14
$sheet.Cells.Item(1,2).font.name = "Consolas"

for ($i=1 ; $i -le 3 ; $i++){
    $sheet.columns.item($i).autofit()#sur coloumns, autofit regle la largeur de colonne.
}

#fond
$sheet.Cells.Item(1,2).Interior.Pattern = 14 #hachures
$sheet.Cells.Item(1,3).Interior.ColorIndex = 44#fond orange

#police pour toutes les cases
$sheet.Cells.font.name = "Arial Black"

$row = $sheet.Rows.Item(1)
$row.autofit() #sur row, autofit concerne la hauteur de ligne


#row est de type Range
#voir https://msdn.microsoft.com/en-us/library/office/ff838238.aspx



#Bordures
$row.Borders.lineStyle = -4118 #ligne pointillé    voir https://msdn.microsoft.com/EN-US/library/office/ff821622.aspx
$row.borders.weight = 1
$row.borders.colorindex = 32 #ligne bleu

$blue = 255
$green = 0
$red = 255
$row.borders.color = [long]($red + $green*256 + $blue*65536) #violet !


#Merged Cells 

#creation
$r = $sheet.range($sheet.Cells.item(2,1)  , $sheet.Cells.item(2,3) ) 
$r.merge()

#detection
$sheet.Cells.item(2,2).Mergecells #true !!
$sheet.Cells.item(2,2).mergeArea.Cells.count #combien de cellules ? 


$row = $sheet.Rows.Item(3)
$i = 10
while ($i -gt 0){
    $row.Cells.item(1) = "Cette fenetre se fermera automatiquement dans $i secondes"
    sleep(1)
    $i--
}

$excel.quit()