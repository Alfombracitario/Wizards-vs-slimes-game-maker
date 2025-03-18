//special for game maker
draw_set_font(Font);
banner_pos = 0;

//variables
rmax = 0;//for rng
rmin = 0;

money = 500; //user can see this
level = 1;
xp = 0;
xpneed = 10;
score = 0;

screen = 1;
selectorpos = 0; 
selx = 0;
sely = 0;
selmode = 0; //pointer/buttons mode
previr1x = 0;
previr1y = 0;

bar = 0; //float variable to use decimals for healthbars
temp = 0; //the same but for other healthbars

//"objects"
tower = array_create(10);

for (var i = 0; i < 10; i++) {
    tower[i] = array_create(6);
    for (var j = 0; j < 6; j++) {
        tower[i][j] = array_create(8);
    }
}
enemypointer = 0;
enemycount = 0;
enemyspawncooldown = 1400;

//iniciar fireballs
fireball = array_create(300);
for (var i = 0; i < 300; i++) {
    fireball[i] = array_create(3); // Cada fila es otro array con 3 elementos
}

fireballpointer = 0;
maxfireballs = 299;
fireballrot = 0;
fireballcount = 0; //just for debug

function create_fireball(_x,_y,_damage)
{
    if(fireballpointer != maxfireballs)
    {
        fireballpointer++;
    }
    else
    {
        fireballpointer = 0;
    }
        fireball[fireballpointer][0] = _x;
        fireball[fireballpointer][1] = _y;
        fireball[fireballpointer][2] = _damage;
    fireballcount++; //then I'll delete this line (maybe)
}
function destroy_fireball(index)
{
    fireball[index][0] = 0;
    fireball[index][1] = 0;
    fireball[index][2] = 0;
    fireballcount--; //this too
}
function heal_tower(_x,_y,_c)
{
    if(tower[_x][_y][0] + _c < tower[_x][_y][6]) //si no pasa el límite
    {
        tower[_x][_y][0] += _c; //curar
    }
    else
    {
        tower[_x][_y][0] = tower[_x][_y][6]; //vida = vidamax
    }
}


function tower_action(_x,_y) //contador llega a 0
{
    switch(tower[_x][_y][4])
    {
        case 0: //lanzador
        case 1: //lanzador 2
            create_fireball(_x << 6,_y,tower[_x][_y][7]);
        break;
        case 2: //aweonao de plata
            money += 25*tower[_x][_y][1];
        break;
        case 7: //maría, digo planta.
        heal_tower(_x,_y,15);
            switch(_x)
            {
                default:
                    heal_tower(_x+1,_y,15);
                    heal_tower(_x-1,_y,15);
                    break;
                case 0: //si está en la izquierda
                    heal_tower(_x+1,_y,15);
                break;

                case 10: //si está en la derecha
                    heal_tower(_x-1,_y,15);
                break;
            }
            switch (_y)
            {
                default:
                    heal_tower(_x,_y+1,15);
                    heal_tower(_x,_y-1,15);
                    break;
                case 0: //si está en la izquierda
                    heal_tower(_x,_y+1,15);
                break;

                case 6: //si está en la derecha
                    heal_tower(_x,_y-1,15);
                break;
            }

        break;
    }
}

//iniciar valores de las torres
pvida =    [25,  250,  1, 150,  500, 5000,    1,  15];
pprecio =  [250, 900, 50, 500, 1500, 5000, 1000, 300];
ptex =     [0,   2,   1,  8,   9,   10,    7,     11];
pcooldown =[120, 30,  600, -1,  -1,  -1,   -1,    120];

maxenemies = 32; //CAMBIA AQUÍ EL MÁXIMO DE ENEMIGOS

enemies = array_create(maxenemies);

for (var i = 0; i < maxenemies; i++)
{
    enemies[i] = {
        eid: -1, 
        ey: 0, 
        hp: 0, 
        color: c_white, 
        damage: 0, 
        knockback: 0, 
        resistance: 0, 
        explode: 0, 
        maxhp: 0, 
        ex: 0, 
        espeed: 0
    };
}

function create_enemy(_tipo,_y)
{
    if (enemycount != maxenemies)
    {
        while (enemies[enemypointer].eid != -1)
        {
            enemypointer++;
            if (enemypointer >= maxenemies)
            {
                enemypointer = 0;
            }
        }
        enemies[enemypointer].eid = enemypointer;
        enemies[enemypointer].ey = _y; // RANDOM
        enemies[enemypointer].ex = 640;
        enemies[enemypointer].damage = round(level * 1.2);
        enemies[enemypointer].hp = min(round(2 * (level * 1.8)),9);//velocidad máxima = 9
        enemies[enemypointer].knockback = -10;
        enemies[enemypointer].explode = 0; //unused variable
        enemies[enemypointer].espeed = -1.3 * (level * 0.16);
        enemies[enemypointer].resistance = 0;

        switch (_tipo)
        {
            default:
            case 0:
                enemies[enemypointer].color = c_lime;
                break;
            case 1:
                enemies[enemypointer].color = c_red;
                enemies[enemypointer].damage = enemies[enemypointer].damage << 2;
                break;
            case 2:
                enemies[enemypointer].color = c_blue;
                enemies[enemypointer].knockback = 0;
                enemies[enemypointer].hp = enemies[enemypointer].hp << 2;
                enemies[enemypointer].espeed *= 0.5;
                enemies[enemypointer].damage = 0;
                break;
            case 3:
                enemies[enemypointer].color = c_orange;
                enemies[enemypointer].resistance = 1;
                break;
            case 4:
                enemies[enemypointer].color = c_purple;
                enemies[enemypointer].espeed *= 1.5;
                break;
            case 5:
                enemies[enemypointer].color = c_gray;
                enemies[enemypointer].hp = enemies[enemypointer].hp << 2;
                enemies[enemypointer].espeed *= 0.5;
                break;
            case 6:
                enemies[enemypointer].color = c_yellow;
                enemies[enemypointer].hp = enemies[enemypointer].hp >> 3;
                enemies[enemypointer].espeed *= 3;
                break;
        }

        enemies[enemypointer].maxhp = enemies[enemypointer].hp;
        enemycount++;
    }
}

function destroy_enemy(_id)
{
    enemies[_id].eid = -1;
    enemies[_id].ex = -1;
    enemies[_id].espeed = -0;
    enemies[_id].hp = 0;
    enemies[_id].explode = 0;
    enemies[_id].color = c_white;
    enemies[_id].resistance = 0;
    enemies[_id].damage = 0;
    enemies[_id].ey = -1;
    enemies[_id].knockback = 0;
    enemycount--;
}
function create_tower(_x,_y,t)
{
    tower[_x][_y][0] = pvida[t];
    tower[_x][_y][1] = 1; //nivel?
    tower[_x][_y][2] = pprecio[t];
    tower[_x][_y][3] = pcooldown[t];//cooldown
    tower[_x][_y][4] = t; //tipo
    tower[_x][_y][5] = tower[_x][_y][3]; //cooldown máximo
    tower[_x][_y][6] = pvida[t]; //vida máxima
    tower[_x][_y][7] = 1; //Propiedad extra
}
function destroy_tower(_x,_y)
{
    tower[_x][_y][0] = 0;
    tower[_x][_y][1] = 0;
    tower[_x][_y][2] = 0;
    tower[_x][_y][3] = 0;
    tower[_x][_y][4] = 0;
    tower[_x][_y][5] = 0;
    tower[_x][_y][6] = 0;
    tower[_x][_y][7] = 0;
}

    //some data
    for (i = 0; i < maxenemies; i++) {
        enemies[i].eid = -1;
    }