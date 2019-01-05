param(
    #I believe the page size is 30 max
    $pagesize = 25,
    $search = "",
    $totalCards = 370,
    $totalHouses = 7
)
$Url = "https://www.keyforgegame.com/api/decks/?page={0}&page_size={1}&search={2}&links=cards" -f "{0}", $pagesize, $search
$page = 1
$cards = [System.Collections.Generic.List[object]]::new()
$houses = [System.Collections.Generic.List[object]]::new()
do {
    $decks = Invoke-RestMethod ($url -f $page++)
    if (($decks._linked.cards | where-object id -notin ($cards.id))) {
        $cards.AddRange(($decks._linked.cards | where-object id -notin ($cards.id)))
    }
    if (($decks._linked.houses | where-object id -notin ($houses.id)).count) {
        $houses.AddRange(($decks._linked.houses | where-object id -notin ($houses.id)))
    }
} while ($cards.Count -lt $totalCards -or $houses.Count -lt $totalHouses -or $page * $pagesize -ge $decks.count)
$cards | ConvertTo-Json -Depth 10 | Out-File -FilePath (Join-Path -Path $PSScriptRoot -ChildPath 'cards.json') -Encoding utf8 -Force
$houses | ConvertTo-Json -Depth 10 | Out-File -FilePath (Join-Path -Path $PSScriptRoot -ChildPath 'houses.json') -Encoding utf8 -Force
