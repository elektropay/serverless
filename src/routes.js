import App from './app';
import { generateAsyncRouteComponent } from './rrv4Helpers';

export default [
  {
    component: App,
    path: parentRoute => `${parentRoute}/`,
    routes: [
      {
        path: parentRoute => `${parentRoute}/`,
        exact: true,
        component: generateAsyncRouteComponent({
          loader: () => import('./all-todos'),
        }),
      },
      {
        path: parentRoute => `${parentRoute}/dev`,
        exact: true,
        component: generateAsyncRouteComponent({
          loader: () => import('./all-todos'),
        }),
      },
      {
        path: parentRoute => `${parentRoute}/all`,
        component: generateAsyncRouteComponent({
          loader: () => import('./all-todos'),
        }),
      },
      {
        path: parentRoute => `${parentRoute}/dev/all`,
        component: generateAsyncRouteComponent({
          loader: () => import('./all-todos'),
        }),
      },
      {
        path: parentRoute => `${parentRoute}/active`,
        component: generateAsyncRouteComponent({
          loader: () => import('./active-todos'),
        }),
      },
      {
        path: parentRoute => `${parentRoute}/dev/active`,
        component: generateAsyncRouteComponent({
          loader: () => import('./active-todos'),
        }),
      },
      {
        path: parentRoute => `${parentRoute}/completed`,
        component: generateAsyncRouteComponent({
          loader: () => import('./completed-todos'),
        }),
      },
      {
        path: parentRoute => `${parentRoute}/dev/completed`,
        component: generateAsyncRouteComponent({
          loader: () => import('./completed-todos'),
        }),
      },
    ],
  },
];
