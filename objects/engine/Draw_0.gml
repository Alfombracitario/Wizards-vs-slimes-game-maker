//draw fireballs
        for (i = 0; i < maxfireballs; i++) {
            if (fireball[i][2] != 0) 
            {
                //we want them to move
                fireball[i][0] += 4;
                if(fireball[i][0] > 640)
                {
                    destroy_fireball(i);
                    continue;
                }
				draw_sprite_ext(GFX_images32,0,fireball[i][0], (fireball[i][1] << 6)+16,1,1,fireball[i][0]<<1,c_white,1);
            }
        }


        //draw towers:
        for (i = 0; i < 10; i++){
            for(j = 0; j < 6; j++){
                if(tower[i][j][0] != 0)
                {
                    i64 = i << 6;
                    j64 = j << 6;
					draw_sprite(GFX_images,ptex[tower[i][j][4]],i64,j64);

                    temp = tower[i][j][6];
                    switch(tower[i][j][4])//uhh this is my way to do it!
                    {

                        case 0: //lanzador
                        case 2: //minero
                        case 7: //planta
                        if(tower[i][j][3]>0) //cooldown logic
                        {
                            tower[i][j][3]--;
                        }
                        else
                        {
                            tower[i][j][3] = tower[i][j][5];
                            tower_action(i,j);
                        }
                        default: //walls
						draw_sprite_ext(GFX_gradient4x,0,i64,j64,(tower[i][j][0]/temp)*16,1,0,c_lime,1);
						draw_text(i64,j64,"Lv: "+string(tower[i][j][1]));
						draw_text(i64,j64+12,"$ "+string(tower[i][j][2]));
                        break;

                        case 1: //lanzador 2
                        if(tower[i][j][3]>0)
                        {
                            tower[i][j][3]--;
                        }
                        else
                        {
                            tower[i][j][3] = tower[i][j][5];
                            tower_action(i,j);
                        }
						draw_sprite_ext(GFX_gradient4x,0,i64,j64,(tower[i][j][0]/temp)*16,1,0,c_lime,1);
                        break;
                        
                        case 6: //teléfono
                        break;
                    }

                }
            }
        }

    //draw enemies
    for (i = 0; i < maxenemies; i++)
    {
        if (enemies[i].hp > 0) //is alive?
        {
            if (enemies[i].ex < 1) //YOU LOSE!!?
            {
                screen = 2;
            }
			draw_sprite_ext(GFX_images,4,enemies[i].ex, enemies[i].ey << 6,1,1,0,enemies[i].color,1);
            enemies[i].ex += enemies[i].espeed;

        // Escaneo de fireballs para detectar colisión
        if(enemies[i].resistance == 0)
        {
            for (j = 0; j < maxfireballs; j++)
            {
                if (enemies[i].ey == fireball[j][1])  // Verifica si están en la misma coordenada Y
                {
                    if (fireball[j][0] > enemies[i].ex)  // Verifica si la fireball está delante del enemigo
                    {
                        enemies[i].hp -= fireball[j][2]; // Resta vida según el daño de la fireball
                        destroy_fireball(j); //destruir la bola de fuego
                        if (enemies[i].hp <= 0)  // Si la vida baja de 0, destruir enemigo
                        {
                            destroy_enemy(i);
                            break; // Salir del loop de fireballs, ya que el enemigo ha sido eliminado
                        }
                    }
                }
            }
        }
        //Lógica de las torres
        if (enemies[i].hp > 0) //is alive?
        {
        tx = floor(enemies[i].ex /64);
        ty = enemies[i].ey;

        if(tower[tx][ty][0] != 0) //si hay una torre en la posición del enemigo
        {
            if(tower[tx][ty][4] == 6) //si es el teléfono
            {
                destroy_enemy(i);
                destroy_tower(tx,ty);
            }
            else
            {
            tower[tx][ty][0] -= enemies[i].damage;
            if(tower[tx][ty][0] <= 0)
            {
                destroy_tower(tx,ty);
                continue; //ya que la torre se eliminó y no hay nada más que revisar, saltar al siguente loop
            }
            enemies[i].resistance = 0;
            enemies[i].ex -= enemies[i].knockback;
            }
        }
    }
}
}       

        //interfaz
        bar = (xp/xpneed)*160;
		draw_sprite_ext(GFX_gradient,0,0,384,160,1,0,c_blue,1);
		draw_sprite_ext(GFX_gradient,0,0,448,160,0.5,0,c_gray,1);
		draw_sprite_ext(GFX_gradient,0,0,448,bar,1,0.5,c_green,1);
		draw_text(0,448,"FPS: "+string(fps));
		draw_text(576,384,"Lv: "+string(level));
		draw_text(576,396,"$: "+string(money));

        //imágenes de la "tienda"
        for (var i = 0; i < 8; i++) {
            var i64 = i << 6;
			draw_sprite(GFX_images,ptex[i],i64,384);
			draw_text(i64,384,"$ "+string(pprecio[i]));
        }
		draw_sprite(GFX_images,6,512, 384);
		draw_sprite(GFX_images,5,selectorpos << 6, 384);
		
        if(selmode == 0 || os_type != os_android || os_type != os_ios)
        {
			draw_sprite(GFX_cursor,14,ir1x,ir1y); //mouse
        }
        else
        {
			draw_sprite_ext(GFX_images,5,selx<<6,sely<<6,1,1,0,c_black,1);
        }