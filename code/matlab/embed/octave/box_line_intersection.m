% function gives two points of intersection of line with the box. Here, line is the bisector of point1 and point2 
function ret=box_line_intersection(box, point1, point2)
  ydiff = point1(2) - point2(2);
  xdiff = point2(1) - point1(1);
  xavg = (point1(1) + point2(1))/2;
  yavg = (point1(2) + point2(2))/2;
  x1 = box(1,1);
  x2 = box(1,2);
  y1 = box(2,1);
  y2 = box(2,2);

  if (xdiff == 0)&&(ydiff == 0)
      error('Points can not be same.');
      return;
  endif

  if ydiff == 0
      ret = [xavg y1; xavg y2];
  elseif xdiff == 0
      ret = [x1 yavg; x2 yavg];
  else
      ret = [];
      m = xdiff/ydiff;
      c = yavg - m*xavg;
      % we define intersection points with the bounding box next, starting
      % with right wall, then top, then left and then bottom
      intersections = [x2 m*x2 + c; (y2 - c)/m y2; x1 m*x1 + c; (y1 - c)/m y1];
      count = 0;
      if (intersections(1,2) >= y1)&&(intersections(1,2) <= y2)
          ret = [ret; intersections(1,1:2)];
          count = count + 1;
      endif
      if (intersections(2,1) >= x1)&&(intersections(2,1) <= x2)
          ret = [ret; intersections(2,1:2)];
          count = count + 1;
      endif
      if (count < 2)&&(intersections(3,2) >= y1)&&(intersections(3,2) <= y2)
          ret = [ret; intersections(3,1:2)];
          count = count + 1;
      endif
      if (count < 2)&&(intersections(4,1) >= x1)&&(intersections(4,1) <= x2)
          ret = [ret; intersections(4,1:2)];
      endif
  endif
endfunction
