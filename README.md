# CheckSMBv1WPF
Check SMBv1 pathes on computers


Numbers of patches was getted in SCCM admin's group (Telegram) and original was "gwmi -Query "Select * from  Win32_QuickFixEngineering WHERE HotFixID = 'KB4012598' OR HotFixID = 'KB4012212' OR HotFixID = 'KB4012215' OR HotFixID = 'KB4015549' OR HotFixID = 'KB4019264' OR HotFixID = 'KB4012213' OR HotFixID = 'KB4012216' OR HotFixID = 'KB4015550' OR HotFixID = 'KB4012214' OR HotFixID = 'KB4012217' OR HotFixID = 'KB4019215' OR HotFixID = 'KB4012606' OR HotFixID = 'KB4019474' OR HotFixID = 'KB4015221' OR HotFixID = 'KB4016637' OR HotFixID = 'KB4013198' OR HotFixID = 'KB4015219' OR HotFixID = 'KB4019473' OR HotFixID = 'KB4016636' OR HotFixID = 'KB4013429' OR HotFixID = 'KB4019472' OR HotFixID = 'KB4015217' OR HotFixID = 'KB4015438' OR HotFixID = 'KB4016635' OR HotFixID = 'KB4015553' OR HotFixID = 'KB4015552' OR HotFixID = 'KB4015551' OR HotFixID = 'KB4019216'" and I forget the author :-
(

In the trunk is a final version of script, in the brunch - scripts by steps.

Кто бы научил по-английски писать правильно..
В общем, список почерпнут из SCCM группы в Telegram - автора запамятовал, что весьма жаль - совершенно не против указать его в качестве автора идеи.
Разумеется, нет никакой нужды так усложнять поиск - можно вообще на каждом компе искать любое из списка, но хотелось изящества, красоты, эстетики и вообще автоматизации.
Результат не идеален, но как бы я мало чего понимаю в PowerShell.
Целью в целом нельзя назвать сам поиск, скорее хотелось посмотреть как PowerShell можно облагородить хоть каким-то GUI для использования в дальнейшем.

Скприт в реальности, понятное дело, не ограничен заданной темой, искать-то можно чего угодно - я и собрал-то его из кусков-запчастей найденных в Интернете и в голове :-)
