program day05_read_file
  implicit none

  ! variables
  integer :: max_seat_demo = 0
  integer :: max_seat_data = 0

  ! functions
  integer :: calc_max_seat

  max_seat_demo = calc_max_seat('demo.txt', 4)
  print*,"Max Seat Demo: ", max_seat_demo

  max_seat_data = calc_max_seat('data.txt', 774)
  print*,"Max Seat Data: ", max_seat_data

  call find_missing_seat()



end program day05_read_file

integer function calc_row(line) result(seat)
  implicit none

  character(len=10), intent(in) :: line ! input
  integer :: min
  integer :: max
  integer :: half
  integer :: cidx

  min = 0
  max = 127
  half = 64

  do cidx = 1, 6
    !print*,line(cidx:cidx)
    select case( line(cidx:cidx) )
    case( 'B' )
      min = min + half
    case( 'F' )
      max = max - half
    case default
      print*, "Unacceptable character!"
      stop 1
    end select
    half = half / 2
  end do
  if (line(7:7) == 'B') then
    seat = max
  else
    seat = min
  end if
end function calc_row

integer function calc_col(line) result(col)
  implicit none

  character(len=10), intent(in) :: line ! input
  integer :: cidx
  integer :: min
  integer :: max
  integer :: Half

  min = 0
  max = 7
  half = 4

  do cidx = 8, 10
    select case( line(cidx:cidx) )
    case( 'R' )
      min = min + half
    case( 'L' )
      max = max - half
    case default
      print*, "Unacceptable character!"
      stop 1
    end select
    half = half / 2
  end do

  if (line(10:10) == 'R') then
    col = max
  else
    col = min
  end if

end function calc_col

integer function calc_max_seat(filename, max_lines) result(max_seat)
  implicit none

  character(len=8), intent(in) :: filename
  integer, intent(in) :: max_lines

  ! variables
  integer :: i
  character(len=10) :: line
  integer :: seat_row
  integer :: seat_col
  integer :: seat_id

  ! functions
  integer :: calc_row
  integer :: calc_col

  max_seat = 0

  ! opening the file for reading
  open (2, file = filename, status = 'old')

  do i = 1,max_lines
    read(2,*) line
    ! print*,line

    seat_row = calc_row(line)
    seat_col = calc_col(line)
    seat_id = seat_row * 8 + seat_col
    print*, "Seat Number", seat_row, ", ", seat_col, ": ", seat_id
    if (seat_id > max_seat) then
      max_seat = seat_id
    end if
  end do

  close(2)
end function calc_max_seat


subroutine find_missing_seat()

  ! variables
  character(len=10) :: line
  integer :: seat_id
  integer :: seat_row
  integer :: seat_col
  integer, dimension(774) :: seats

  ! functions
  integer :: calc_row
  integer :: calc_col

  ! opening the file for reading
  open (2, file = 'data.txt', status = 'old')

  do i = 1,774
    read(2,*) line
    seat_row = calc_row(line)
    seat_col = calc_col(line)
    seat_id = seat_row * 8 + seat_col
    seats(i) = seat_id
  end do

  call quicksort(seats, 1, 774)

  do i = 2, 773
    if (.NOT.(seats(i-1) + 1 == seats(i))) then
      print*, "Missing ID:", seats(i-1) + 1
    end if
    if (.NOT.(seats(i+1) - 1 == seats(i))) then
      print*, "Missing ID:", seats(i+1) - 1
    end if
  end do

end subroutine

! quicksort.f -*-f90-*-
! Author: t-nissie
! License: GPLv3
! Gist: https://gist.github.com/t-nissie/479f0f16966925fa29ea
!!
recursive subroutine quicksort(a, first, last)
  implicit none
  integer a(*), x, t
  integer first, last
  integer i, j

  x = a( (first+last) / 2 )
  i = first
  j = last
  do
     do while (a(i) < x)
        i=i+1
     end do
     do while (x < a(j))
        j=j-1
     end do
     if (i >= j) exit
     t = a(i);  a(i) = a(j);  a(j) = t
     i=i+1
     j=j-1
  end do
  if (first < i-1) call quicksort(a, first, i-1)
  if (j+1 < last)  call quicksort(a, j+1, last)
end subroutine quicksort
