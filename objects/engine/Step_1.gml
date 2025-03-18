		ir1x = mouse_x;
		ir1y = mouse_y;
		
		#region Game maker
		if(ir1x > room_width)
		{
			ir1x = room_width-1;
		}
		if(ir1x < 0)
		{
			ir1x = 0;
		}
		banner_pos++;
		
		#endregion
		
        mousex = ir1x >> 6;
        mousey = ir1y >> 6;

        if(abs(ir1x - previr1x) > 3 || abs(ir1y - previr1y) > 3)
        {
            selmode = 0;
        }
        previr1x = ir1x;
        previr1y = ir1y;
        
		if(gamepad_button_check_pressed(0,gp_start) || gamepad_button_check_pressed(0,gp_shoulderr))
		{
			if selectorpos < 8  selectorpos++;
		}
		if(gamepad_button_check_pressed(0,gp_select)|| gamepad_button_check_pressed(0,gp_shoulderl))
        {
            if(selectorpos > 0) selectorpos--;
        }

        //selector
        if(gamepad_button_check_pressed(0,gp_padr) || keyboard_check_pressed(vk_right))
        {
            if(selx < 9) selx ++;
            selmode = 1;
        }
        if(gamepad_button_check_pressed(0,gp_padl) || keyboard_check_pressed(vk_left))
        {
            if(selx > 0) selx --;
            selmode = 1;
        }
        if(gamepad_button_check_pressed(0,gp_padd) || keyboard_check_pressed(vk_down))
        {
            if(sely < 5) sely ++;
            selmode = 1;
        }
        if(gamepad_button_check_pressed(0,gp_padu) || keyboard_check_pressed(vk_up))
        {
            if(sely > 0) sely --;
            selmode = 1;
        }
        if(gamepad_button_check(0,gp_face1))
        {
            if(sely < 6)
            {
            destroy_tower(selx,sely);
            }
        }
        if(mouse_check_button_pressed(mb_right))
        {
            if(mousey < 6)
            {
            destroy_tower(mousex,mousey);
            }
        }

        if(gamepad_button_check_pressed(0,gp_face2) || mouse_check_button_pressed(mb_left))
        {
            if(selmode == 1)
            {
                mousex = selx;
                mousey = sely;
            }
            if(mousey < 6)
            {
                if(selectorpos != 8)
                {
                    if(tower[mousex][mousey][0] == 0 && money >= pprecio[selectorpos]) //Crea una torre
                    {
                        money -= pprecio[selectorpos];
                        create_tower(mousex,mousey,selectorpos);
                    }
                    else
                    { 
                        if (money >= tower[mousex][mousey][2] && tower[mousex][mousey][4] != 1 && tower[mousex][mousey][4] != 6)//subir de nivel una torre
                        {
                            money -= tower[mousex][mousey][2]; //quitar plata
                            tower[mousex][mousey][2] = round((tower[mousex][mousey][2]*1.5)/25)*25; //cambiar precio
                            tower[mousex][mousey][0] = tower[mousex][mousey][6] << 1; //actualizar vida
                            tower[mousex][mousey][6] = tower[mousex][mousey][0]; //actualizar vida máxima
                            tower[mousex][mousey][1]++; //subir el contador de niveles
                            switch(tower[mousex][mousey][4])//COOLDOWN!!1
                            {
                                case 0://lanzador 1
                                    if(tower[mousex][mousey][4] >= pcooldown[0]>>1)
                                    {
                                        tower[mousex][mousey][3]-=5;
                                    }
                                    else
                                    {
                                        tower[mousex][mousey][3] = pcooldown[0];
                                        tower[mousex][mousey][7] = tower[mousex][mousey][7] << 1;
                                    }
                                break;
                                case 2://minero
                                    if(tower[mousex][mousey][4] >= pcooldown[2]>>2)
                                    {
                                        tower[mousex][mousey][4] -= 5;
                                    }
                                case 7://planta
                                    if(tower[mousex][mousey][3] >= 10)
                                    {
                                        tower[mousex][mousey][3]-=5;
                                    }
                                break;
                            }
                        }
                    }
                }
                else
                {
                    destroy_tower(mousex,mousey);
                }
            }
            else
            {
                if(mousex != 9)
                {
                    selectorpos = mousex;
                }
            }
        }

        if(enemyspawncooldown > 0)//enemy spawner
        {
            enemyspawncooldown--;
        }
        else
        {
            score += level;
             
		pos = irandom(5);
		show_debug_message(pos)
		rmin = 0;
		rmax = min(level, 12);
		rtipo = irandom_range(rmin, rmax);
                switch(rtipo)
                {
                    default:
                    create_enemy(0,pos);
                    break;
                    case 2:
                    create_enemy(5,pos);
                    break;

                    case 3:
                    create_enemy(6,pos);
                    break;

                    case 5:
                    create_enemy(2,pos);
                    break;

                    case 7:
                    create_enemy(4,pos);
                    break;

                    case 10:
                    create_enemy(3,pos);
                    break;

                    case 12:
                    create_enemy(1,pos);
                    break;
                }
                if(600/level >=  5)
                {
                    enemyspawncooldown = 600/level;
                }
                else
                {
                    enemyspawncooldown = 5;
                }
            
            if(xp < xpneed)
            {
                xp++;
            }
            else
            {
                xpneed = floor(xpneed*1.1);
                xp = 0;
                level++;
            }
        }
		if screen != 1 exit;