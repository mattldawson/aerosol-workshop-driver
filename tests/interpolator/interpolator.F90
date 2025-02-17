! Copyright (C) 2022 National Center for Atmospheric Research,
! National Technology & Engineering Solutions of Sandia, LLC (NTESS),
! and the U.S. Environmental Protection Agency (USEPA)
!
! SPDX-License-Identifier: Apache-2.0
!
program test_interpolator

  use aero_interpolator,               only : interpolator_t

  implicit none

  call test_interpolator_t( )

contains

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  subroutine test_interpolator_t( )

    use aero_array,                    only : array_t
    use aero_constants,                only : rk => real_kind
    use aero_grid,                     only : grid_t
    use aero_util,                     only : assert, almost_equal

    class(array_t), pointer :: from_interfaces, to_interfaces
    class(array_t), pointer :: from_data, to_data
    type(grid_t) :: from_grid, to_grid
    type(interpolator_t) :: interp
    real(kind=rk), pointer :: to_a(:)

    from_interfaces => array_t( (/ 1.0_rk, 11.0_rk, 51.0_rk, 61.0_rk /) )
    from_data       => array_t( (/ 5.0_rk, 10.0_rk, 2.0_rk, 0.0_rk /) )
    to_interfaces   => array_t( (/ 0.0_rk,  6.0_rk, 11.0_rk, 56.0_rk,         &
                                  57.0_rk /) )
    to_data         => array_t( 5, 0.0_rk )

    from_grid = grid_t( from_interfaces )
    to_grid   = grid_t(   to_interfaces )

    interp = interpolator_t( from_grid, to_grid )
    call interp%interpolate( from_data, to_data )
    to_a => to_data%data( )
    call assert( 843705688, almost_equal( to_a(1), 5.0_rk ) )
    call assert( 615710225, almost_equal( to_a(2), 7.5_rk ) )
    call assert( 163078072, almost_equal( to_a(3), 10.0_rk ) )
    call assert( 957929567, almost_equal( to_a(4), 1.0_rk ) )
    call assert( 235435633, almost_equal( to_a(5), 0.8_rk ) )

    deallocate( from_data )
    deallocate(   to_data )

  end subroutine test_interpolator_t

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end program test_interpolator
