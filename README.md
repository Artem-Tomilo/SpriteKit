# SpriteKit
#### Основной используемый стек: SpriteKit, UIKit, CoreData, Navigation Controller. 

### 
1) Проект написан на SpriteKit + UIKit
2) Сохранение векторов между запусками приложения осуществляется с помощью CoreData.
3) Side-меню реализовано через TableView + кастомную ячейку. 
___
### Реализовано приложение, демонстрирующее простейшую работу с векторами в 2D-пространстве.
1. Главный экран показывает 2D-полотно, на котором можно задавать и откладывать различные вектора. Есть возможность двигать полотно по направлениям право-лево, верх-низ средствами pan-жеста. Задание параметров нового вектора происходит на отдельном экране, который открывается по нажатию на кнопку “+”. Каждый вектор отрисовывается стрелкой рандомного цвета. Количество векторов, которое можно создать, не ограничено.

<img src="https://github.com/Artem-Tomilo/SpriteKit/blob/main/TestTaskSpriteKit/screens/1.png" width="200"> <img src="https://github.com/Artem-Tomilo/SpriteKit/blob/main/TestTaskSpriteKit/screens/2.png" width="200"> <img src="https://github.com/Artem-Tomilo/SpriteKit/blob/main/TestTaskSpriteKit/screens/3.png" width="200">

2. Реализовано Side-меню выезжающее слева на 1/3 часть экрана, которое отображает список созданных векторов с их координатами и длиной. Кроме того, side-меню позволяет удалять вектора. По нажатию на элемент списка в side-меню соответствующий вектор будет на секунду подсвечен большей толщиной линии в 2D-пространстве.

<img src="https://github.com/Artem-Tomilo/SpriteKit/blob/main/TestTaskSpriteKit/screens/4.png" width="200"> <img src="https://github.com/Artem-Tomilo/SpriteKit/blob/main/TestTaskSpriteKit/screens/5.png" width="200">

3. Реализована возможность редактировать вектор long-press-жестом, перетягивая его конечную или начальную точку. Так же есть возможность параллельно переносить вектор целиком.

<img src="https://github.com/Artem-Tomilo/SpriteKit/blob/main/TestTaskSpriteKit/screens/6.png" width="200"> <img src="https://github.com/Artem-Tomilo/SpriteKit/blob/main/TestTaskSpriteKit/screens/7.png" width="200">

4. Приложение сохраняет заданные вектора между запусками приложения средствами CoreData. Механика 2D-полотна реализована средствами SpriteKit.
