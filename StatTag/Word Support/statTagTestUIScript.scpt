FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        i      	 
 	 I      �� ���� "0 managecodefiles manageCodeFiles   ��  o      ���� 0 arg  ��  ��   
 k     "       l     ��������  ��  ��        l     ��  ��     	set arg2 to arg as text     �   0 	 s e t   a r g 2   t o   a r g   a s   t e x t      l     ��  ��    L F	display dialog "Enter your text here... (" & arg & ") (" & arg2 & ")"     �   � 	 d i s p l a y   d i a l o g   " E n t e r   y o u r   t e x t   h e r e . . .   ( "   &   a r g   &   " )   ( "   &   a r g 2   &   " ) "      l     ��������  ��  ��        l     ��  ��    4 .if application "StatTagTestUI" is running then     �     \ i f   a p p l i c a t i o n   " S t a t T a g T e s t U I "   i s   r u n n i n g   t h e n   ! " ! l     �� # $��   # 
 else    $ � % %  e l s e "  & ' & l     �� ( )��   ( + %	activate application "StatTagTestUI"    ) � * * J 	 a c t i v a t e   a p p l i c a t i o n   " S t a t T a g T e s t U I " '  + , + l     �� - .��   -  
	delay 2.0    . � / /  	 d e l a y   2 . 0 ,  0 1 0 l     �� 2 3��   2  end if    3 � 4 4  e n d   i f 1  5 6 5 l     ��������  ��  ��   6  7 8 7 l     �� 9 :��   9  if appIsInstalled() then    : � ; ; 0 i f   a p p I s I n s t a l l e d ( )   t h e n 8  < = < l     �� > ?��   >  	return true    ? � @ @  	 r e t u r n   t r u e =  A B A l     �� C D��   C 
 else    D � E E  e l s e B  F G F l     �� H I��   H  	return false    I � J J  	 r e t u r n   f a l s e G  K L K l     �� M N��   M  end if    N � O O  e n d   i f L  P Q P l     ��������  ��  ��   Q  R S R I    �� T��
�� .miscactvnull��� ��� null T m      U U�                                                                                      @ alis    8  Macintosh HD               �<*�H+  ��StatTag.app                                                    ��	ɻ        ����  	                Debug     �<q      �
    (������??��n 	} 	| 3 �  �1  �Macintosh HD:Users: ewhitley: Library: Developer: Xcode: DerivedData: StatTag-cleegsqxxdlbkcb#53F3F9F: Build: Products: Debug: StatTag.app    S t a t T a g . a p p    M a c i n t o s h   H D  xUsers/ewhitley/Library/Developer/Xcode/DerivedData/StatTag-cleegsqxxdlbkcbhryezxamefxmw/Build/Products/Debug/StatTag.app  /    ��  ��   S  V W V l   ��������  ��  ��   W  X Y X l   ��������  ��  ��   Y  Z [ Z r     \ ] \ c    	 ^ _ ^ m    ��
�� boovfals _ m    ��
�� 
bool ] o      ���� 0 mynewresult myNewResult [  ` a ` l   ��������  ��  ��   a  b c b l   �� d e��   d b \http://apple.stackexchange.com/questions/121810/waiting-until-a-window-exists-in-applescript    e � f f � h t t p : / / a p p l e . s t a c k e x c h a n g e . c o m / q u e s t i o n s / 1 2 1 8 1 0 / w a i t i n g - u n t i l - a - w i n d o w - e x i s t s - i n - a p p l e s c r i p t c  g h g l   �� i j��   i W Qhttp://stackoverflow.com/questions/12498897/applescript-appleevent-handler-failed    j � k k � h t t p : / / s t a c k o v e r f l o w . c o m / q u e s t i o n s / 1 2 4 9 8 8 9 7 / a p p l e s c r i p t - a p p l e e v e n t - h a n d l e r - f a i l e d h  l m l l   ��������  ��  ��   m  n o n O     p q p k     r r  s t s l   ��������  ��  ��   t  u v u l    �� w x��   w � �		tell application "System Events"			if (window 1 of process "StatTagTestUI" exists) then				return "xyz"			end if		end tell		    x � y y  	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "  	 	 	 i f   ( w i n d o w   1   o f   p r o c e s s   " S t a t T a g T e s t U I "   e x i s t s )   t h e n  	 	 	 	 r e t u r n   " x y z "  	 	 	 e n d   i f  	 	 e n d   t e l l  	 	 v  z { z l   ��������  ��  ��   {  | } | l    �� ~ ��   ~ � �
		--no can do - assistive events...		tell application "System Events"			repeat until window "StatTagTestUI" of process "StatTagTestUI" exists			end repeat		end tell
		     � � �X 
 	 	 - - n o   c a n   d o   -   a s s i s t i v e   e v e n t s . . .  	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "  	 	 	 r e p e a t   u n t i l   w i n d o w   " S t a t T a g T e s t U I "   o f   p r o c e s s   " S t a t T a g T e s t U I "   e x i s t s  	 	 	 e n d   r e p e a t  	 	 e n d   t e l l 
 	 	 }  � � � l   ��������  ��  ��   �  � � � l    �� � ���   � � �		set startTime to current date		repeat until exists window 1			delay 0.2			if (current date) - startTime is greater than 10 then return -- a precaution so you don't get stuck in the repeat loop forever		end repeat		    � � � ��  	 	 s e t   s t a r t T i m e   t o   c u r r e n t   d a t e  	 	 r e p e a t   u n t i l   e x i s t s   w i n d o w   1  	 	 	 d e l a y   0 . 2  	 	 	 i f   ( c u r r e n t   d a t e )   -   s t a r t T i m e   i s   g r e a t e r   t h a n   1 0   t h e n   r e t u r n   - -   a   p r e c a u t i o n   s o   y o u   d o n ' t   g e t   s t u c k   i n   t h e   r e p e a t   l o o p   f o r e v e r  	 	 e n d   r e p e a t  	 	 �  � � � l   ��������  ��  ��   �  � � � r     � � � I   ������
�� .STMNGCFLnull��� ��� null��  ��   � o      ���� 0 mynewresult myNewResult �  � � � L     � � o    ���� 0 mynewresult myNewResult �  � � � l   �� � ���   �  tell me to log myResult    � � � � . t e l l   m e   t o   l o g   m y R e s u l t �  ��� � l   �� � ���   � &  tell me to log "inside function"    � � � � @ t e l l   m e   t o   l o g   " i n s i d e   f u n c t i o n "��   q m     � ��                                                                                      @ alis    8  Macintosh HD               �<*�H+  ��StatTag.app                                                    ��	ɻ        ����  	                Debug     �<q      �
    (������??��n 	} 	| 3 �  �1  �Macintosh HD:Users: ewhitley: Library: Developer: Xcode: DerivedData: StatTag-cleegsqxxdlbkcb#53F3F9F: Build: Products: Debug: StatTag.app    S t a t T a g . a p p    M a c i n t o s h   H D  xUsers/ewhitley/Library/Developer/Xcode/DerivedData/StatTag-cleegsqxxdlbkcbhryezxamefxmw/Build/Products/Debug/StatTag.app  /    ��   o  � � � l   ��������  ��  ��   �  � � � L      � � o    ���� 0 mynewresult myNewResult �  � � � l  ! !�� � ���   � ! set myResult to "x" as text    � � � � 6 s e t   m y R e s u l t   t o   " x "   a s   t e x t �  � � � l  ! !�� � ���   �  return myResult    � � � �  r e t u r n   m y R e s u l t �  ��� � l  ! !��������  ��  ��  ��     � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� 0 opensettings openSettings �  ��� � o      ���� 0 arg  ��  ��   � k       � �  � � � l     ��������  ��  ��   �  � � � I    �� ���
�� .miscactvnull��� ��� null � m      � ��                                                                                      @ alis    8  Macintosh HD               �<*�H+  ��StatTag.app                                                    ��	ɻ        ����  	                Debug     �<q      �
    (������??��n 	} 	| 3 �  �1  �Macintosh HD:Users: ewhitley: Library: Developer: Xcode: DerivedData: StatTag-cleegsqxxdlbkcb#53F3F9F: Build: Products: Debug: StatTag.app    S t a t T a g . a p p    M a c i n t o s h   H D  xUsers/ewhitley/Library/Developer/Xcode/DerivedData/StatTag-cleegsqxxdlbkcbhryezxamefxmw/Build/Products/Debug/StatTag.app  /    ��  ��   �  � � � l   ��������  ��  ��   �  � � � r     � � � c    	 � � � m    ��
�� boovfals � m    ��
�� 
bool � o      ���� 0 mynewresult myNewResult �  � � � O     � � � k     � �  � � � r     � � � I   ������
�� .STOPNSTGnull��� ��� null��  ��   � o      ���� 0 mynewresult myNewResult �  ��� � L     � � o    ���� 0 mynewresult myNewResult��   � m     � ��                                                                                      @ alis    8  Macintosh HD               �<*�H+  ��StatTag.app                                                    ��	ɻ        ����  	                Debug     �<q      �
    (������??��n 	} 	| 3 �  �1  �Macintosh HD:Users: ewhitley: Library: Developer: Xcode: DerivedData: StatTag-cleegsqxxdlbkcb#53F3F9F: Build: Products: Debug: StatTag.app    S t a t T a g . a p p    M a c i n t o s h   H D  xUsers/ewhitley/Library/Developer/Xcode/DerivedData/StatTag-cleegsqxxdlbkcbhryezxamefxmw/Build/Products/Debug/StatTag.app  /    ��   �  � � � l   ��������  ��  ��   �  � � � L     � � o    ���� 0 mynewresult myNewResult �  ��� � l   ��������  ��  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i     � � � I      ��������  0 appisinstalled appIsInstalled��  ��   � k      � �  � � � e      � � n      � � � 1    ��
�� 
ID   � m      � ��                                                                                      @ alis    8  Macintosh HD               �<*�H+  ��StatTag.app                                                    ��	ɻ        ����  	                Debug     �<q      �
    (������??��n 	} 	| 3 �  �1  �Macintosh HD:Users: ewhitley: Library: Developer: Xcode: DerivedData: StatTag-cleegsqxxdlbkcb#53F3F9F: Build: Products: Debug: StatTag.app    S t a t T a g . a p p    M a c i n t o s h   H D  xUsers/ewhitley/Library/Developer/Xcode/DerivedData/StatTag-cleegsqxxdlbkcbhryezxamefxmw/Build/Products/Debug/StatTag.app  /    ��   �  � � � Q     � � � � I   �� ���
�� .coredoexbool       obj  � 5    � ��~
� 
capp � m   
  � � � � � & o r g . s t a t t a g . S t a t T a g
�~ kfrmID  ��   � R      �}�|�{
�} .ascrerr ****      � ****�|  �{   � L     � � m    �z
�z boovfals �  ��y � L     � � m    �x
�x boovtrue�y   �  � � � l     �w�v�u�w  �v  �u   �  � � � i     � � � I     �t ��s
�t .sysodelanull��� ��� nmbr � o      �r�r 0 duration  �s   � k     + � �  � � � r     	 � � � [      � � � l     ��q�p � I    �o�n�m
�o .misccurdldt    ��� null�n  �m  �q  �p   � o    �l�l 0 duration   � o      �k�k 0 endtime endTime �  ��j � V   
 + �  � O   & I   %�i�h
�i .sysodelanull��� ��� nmbr \    ! o    �g�g 0 endtime endTime l    �f�e I    �d�c�b
�d .misccurdldt    ��� null�c  �b  �f  �e  �h   1    �a
�a 
ascr  A    l   	�`�_	 I   �^�]�\
�^ .misccurdldt    ��� null�]  �\  �`  �_   o    �[�[ 0 endtime endTime�j   � 

 l     �Z�Y�X�Z  �Y  �X    l     �W�W    TestStatTag("")    �  T e s t S t a t T a g ( " " ) �V l     �U�T�S�U  �T  �S  �V       �R�R   �Q�P�O�N�Q "0 managecodefiles manageCodeFiles�P 0 opensettings openSettings�O  0 appisinstalled appIsInstalled
�N .sysodelanull��� ��� nmbr �M 
�L�K�J�M "0 managecodefiles manageCodeFiles�L �I�I   �H�H 0 arg  �K   �G�F�G 0 arg  �F 0 mynewresult myNewResult  U�E�D�C
�E .miscactvnull��� ��� null
�D 
bool
�C .STMNGCFLnull��� ��� null�J #�j Of�&E�O� *j E�O�OPUO�OP �B ��A�@�?�B 0 opensettings openSettings�A �>�>   �=�= 0 arg  �@   �<�;�< 0 arg  �; 0 mynewresult myNewResult  ��:�9�8
�: .miscactvnull��� ��� null
�9 
bool
�8 .STOPNSTGnull��� ��� null�? !�j Of�&E�O� *j E�O�UO�OP �7 ��6�5�4�7  0 appisinstalled appIsInstalled�6  �5      ��3�2 ��1�0�/�.
�3 
ID  
�2 
capp
�1 kfrmID  
�0 .coredoexbool       obj �/  �.  �4 ��,EO )���0j W 	X  fOe �- ��,�+ �*
�- .sysodelanull��� ��� nmbr�, 0 duration  �+   �)�(�) 0 duration  �( 0 endtime endTime  �'�&�%
�' .misccurdldt    ��� null
�& 
ascr
�% .sysodelanull��� ��� nmbr�* ,*j  �E�O  h*j  �� �*j  j U[OY�� ascr  ��ޭ