// Copyright (c) 1998-2021
// Utrecht University (The Netherlands),
// ETH Zurich (Switzerland),
// INRIA Sophia-Antipolis (France),
// Max-Planck-Institute Saarbruecken (Germany),
// and Tel-Aviv University (Israel).  All rights reserved.
//
// This file is part of CGAL (www.cgal.org)
//
// $URL$
// $Id$
// SPDX-License-Identifier: LGPL-3.0-or-later OR LicenseRef-Commercial
//
//
// Author(s)     : Geert-Jan Giezeman, Andreas Fabri

#ifndef CGAL_DISTANCE_3_POINT_3_PLANE_3_H
#define CGAL_DISTANCE_3_POINT_3_PLANE_3_H

#include <CGAL/Distance_3/internal/squared_distance_utils_3.h>

#include <CGAL/Point_3.h>
#include <CGAL/Plane_3.h>

namespace CGAL {
namespace internal {

template <class K>
inline typename K::FT
squared_distance(const typename K::Point_3& pt,
                 const typename K::Plane_3& plane,
                 const K& k)
{
  typedef typename K::Vector_3 Vector_3;

  typename K::Construct_vector_3 vector = k.construct_vector_3_object();

  Vector_3 diff = vector(plane.point(), pt);
  return squared_distance_to_plane(plane.orthogonal_vector(), diff, k);
}

template <class K>
inline typename K::FT
squared_distance(const typename K::Plane_3& plane,
                 const typename K::Point_3& pt,
                 const K& k)
{
  return squared_distance(pt, plane, k);
}

template <class K>
inline typename K::Comparison_result
compare_squared_distance(const typename K::Point_3& pt,
                         const typename K::Plane_3& plane,
                         const K& k,
                         const typename K::FT& d2)
{
  return ::CGAL::compare(squared_distance(pt, plane, k), d2);
}

template <class K>
inline typename K::Comparison_result
compare_squared_distance(const typename K::Plane_3& plane,
                         const typename K::Point_3& pt,
                         const K& k,
                         const typename K::FT& d2)
{
  return compare_squared_distance(pt, plane, k, d2);
}

} } // namespace CGAL::internal

#endif // CGAL_DISTANCE_3_POINT_3_PLANE_3_H
