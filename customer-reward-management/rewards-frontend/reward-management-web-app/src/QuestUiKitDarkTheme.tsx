import React from 'react';

import { createTheme } from '@mui/material/styles';

import SvgIcon from '@mui/material/SvgIcon';

import { ReactComponent as IconInfo } from 'src/assets/images/_IconInfo.svg';
import { ReactComponent as IconAlert } from 'src/assets/images/_IconAlert_1.svg';
import { ReactComponent as IconInfo1 } from 'src/assets/images/_IconInfo.svg';
import { ReactComponent as IconSuccess } from 'src/assets/images/_IconSuccess.svg';
import { ReactComponent as IconUnchecked } from 'src/assets/images/_IconUnchecked.svg';
import { ReactComponent as IconChecked } from 'src/assets/images/_IconChecked.svg';
import { ReactComponent as IconMixed } from 'src/assets/images/_IconMixed.svg';

const darkGlobalTheme: any = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: 'rgba(208, 207, 246, 1)',
      contrastText: 'rgba(0, 0, 0, 0.9)',
    },
    secondary: {
      main: 'rgba(194, 238, 252, 1)',
      contrastText: 'rgba(0, 0, 0, 0.9)',
    },
    error: {
      main: 'rgba(249, 206, 219, 1)',
      contrastText: 'rgba(0, 0, 0, 0.9)',
    },
    warning: {
      main: 'rgba(251, 220, 191, 1)',
      contrastText: 'rgba(0, 0, 0, 0.9)',
    },
    success: {
      main: 'rgba(205, 239, 208, 1)',
      contrastText: 'rgba(0, 0, 0, 0.9)',
    },
    info: {
      main: 'rgba(205, 232, 252, 1)',
      contrastText: 'rgba(0, 0, 0, 0.9)',
    },
    text: {
      primary: 'rgba(255, 255, 255, 1)',
      secondary: 'rgba(207, 207, 207, 1)',
      disabled: 'rgba(175, 175, 175, 1)',
    },
    action: {
      active: 'rgba(255, 255, 255, 0.54)',
      selected: 'rgba(255, 255, 255, 0.09)',
      focus: 'rgba(255, 255, 255, 0.14)',
    },
    Primary: {
      Main: 'rgba(208, 207, 246, 1)',
      Contrast: 'rgba(0, 0, 0, 0.9)',
      Shades: {
        '4p': 'rgba(208, 207, 246, 0.04)',
        '8p': 'rgba(208, 207, 246, 0.08)',
        '12p': 'rgba(208, 207, 246, 0.12)',
        '30p': 'rgba(208, 207, 246, 0.3)',
        '50p': 'rgba(208, 207, 246, 0.5)',
      },
    },
    Secondary: {
      Main: 'rgba(194, 238, 252, 1)',
      Contrast: 'rgba(0, 0, 0, 0.9)',
      Shades: {
        '4p': 'rgba(194, 238, 252, 0.04)',
        '8p': 'rgba(194, 238, 252, 0.08)',
        '12p': 'rgba(194, 238, 252, 0.12)',
        '30p': 'rgba(194, 238, 252, 0.3)',
        '50p': 'rgba(194, 238, 252, 0.5)',
      },
    },
    Error: {
      Main: 'rgba(249, 206, 219, 1)',
      Contrast: 'rgba(0, 0, 0, 0.9)',
      Shades: {
        '4p': 'rgba(249, 206, 219, 0.04)',
        '8p': 'rgba(249, 206, 219, 0.08)',
        '12p': 'rgba(249, 206, 219, 0.12)',
        '30p': 'rgba(249, 206, 219, 0.3)',
        '50p': 'rgba(249, 206, 219, 0.5)',
      },
    },
    Warning: {
      Main: 'rgba(251, 220, 191, 1)',
      Contrast: 'rgba(0, 0, 0, 0.9)',
      Shades: {
        '4p': 'rgba(251, 220, 191, 0.04)',
        '8p': 'rgba(251, 220, 191, 0.08)',
        '12p': 'rgba(251, 220, 191, 0.12)',
        '30p': 'rgba(251, 220, 191, 0.3)',
        '50p': 'rgba(251, 220, 191, 0.5)',
      },
    },
    Info: {
      Main: 'rgba(205, 232, 252, 1)',
      Contrast: 'rgba(0, 0, 0, 0.9)',
      Shades: {
        '4p': 'rgba(205, 232, 252, 0.04)',
        '8p': 'rgba(205, 232, 252, 0.08)',
        '12p': 'rgba(205, 232, 252, 0.12)',
        '30p': 'rgba(205, 232, 252, 0.3)',
        '50p': 'rgba(205, 232, 252, 0.5)',
      },
    },
    Success: {
      Main: 'rgba(205, 239, 208, 1)',
      Contrast: 'rgba(0, 0, 0, 0.9)',
      Shades: {
        '4p': 'rgba(205, 239, 208, 0.04)',
        '8p': 'rgba(205, 239, 208, 0.08)',
        '12p': 'rgba(205, 239, 208, 0.12)',
        '30p': 'rgba(205, 239, 208, 0.3)',
        '50p': 'rgba(205, 239, 208, 0.5)',
      },
    },
    Text: {
      Primary: 'rgba(255, 255, 255, 1)',
      Secondary: 'rgba(207, 207, 207, 1)',
      Disabled: 'rgba(175, 175, 175, 1)',
    },
    Action: {
      'Active (54p)': 'rgba(255, 255, 255, 0.54)',
      Hover: 'rgba(255, 255, 255, 0.18)',
      'Selected (8p)': 'rgba(255, 255, 255, 0.09)',
      Disabled: 'rgba(255, 255, 255, 0.42)',
      'Disabled Background': 'rgba(255, 255, 255, 0.24)',
      'Focus (12p)': 'rgba(255, 255, 255, 0.14)',
    },
    Background: {
      Background: 'rgba(18, 18, 18, 1)',
      Paper: {},
    },
    Other: {
      Divider: 'rgba(255, 255, 255, 0.15)',
      'Border (23p)': 'rgba(255, 255, 255, 0.23)',
      'Backdrop Overlay': 'rgba(255, 255, 255, 0.5)',
      'Standard Input Line': 'rgba(255, 255, 255, 0.42)',
      'Filled Input Background': 'rgba(255, 255, 255, 0.1)',
      Snackbar: 'rgba(215, 215, 215, 1)',
      Tooltip: 'rgba(228, 228, 228, 1)',
      'Rating Active': 'rgba(252, 243, 198, 1)',
      'focus-ring-color': 'rgba(206, 196, 254, 1)',
    },
    Common: {
      Black: {
        '4p': 'rgba(0, 0, 0, 0.04)',
        '12p': 'rgba(0, 0, 0, 0.12)',
        '30p': 'rgba(0, 0, 0, 0.3)',
        '100p': 'rgba(0, 0, 0, 1)',
      },
      White: {
        '4p': 'rgba(255, 255, 255, 0.04)',
        '12p': 'rgba(255, 255, 255, 0.12)',
        '30p': 'rgba(255, 255, 255, 0.3)',
        '100p': 'rgba(255, 255, 255, 1)',
      },
    },
  },
  typography: {
    Typography: {
      H1: {
        fontStyle: 'normal',
        fontFamily: 'Poppins',
        fontWeight: 800,
        fontSize: '72px',
        letterSpacing: '-2.16px',
        textDecoration: 'none',
        lineHeight: '100%',
        textTransform: 'none',
      },
      H2: {
        fontStyle: 'normal',
        fontFamily: 'Poppins',
        fontWeight: 700,
        fontSize: '60px',
        letterSpacing: '-3px',
        textDecoration: 'none',
        lineHeight: '100%',
        textTransform: 'none',
      },
      H3: {
        fontStyle: 'normal',
        fontFamily: 'Poppins',
        fontWeight: 700,
        fontSize: '48px',
        letterSpacing: '-1.44px',
        textDecoration: 'none',
        lineHeight: '100%',
        textTransform: 'none',
      },
      H4: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 800,
        fontSize: '34px',
        letterSpacing: '-1.36px',
        textDecoration: 'none',
        lineHeight: '100%',
        textTransform: 'none',
      },
      H5: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 800,
        fontSize: '24px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '28px',
        textTransform: 'none',
      },
      H6: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 600,
        fontSize: '22px',
        letterSpacing: '0px',
        textDecoration: 'none',
        textTransform: 'none',
      },
      'Body 1': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '20px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '26px',
        textTransform: 'none',
      },
      'Body 2': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '16px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '150%',
        textTransform: 'none',
      },
      'Body 3': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '14px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '18px',
        textTransform: 'none',
      },
      'Body 1 Link': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '20px',
        letterSpacing: '0px',
        textDecoration: 'none',
        textTransform: 'none',
      },
      'Body 2 Link': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '16px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '150%',
        textTransform: 'none',
      },
      'Body 3 Link': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '14px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '18px',
        textTransform: 'none',
      },
      Caption: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '12px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '160.0000023841858%',
        textTransform: 'none',
      },
      Overline: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 600,
        fontSize: '12px',
        letterSpacing: '0.12px',
        textDecoration: 'none',
        lineHeight: '250%',
        textTransform: 'uppercase',
      },
      'Subtitle 2': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '14px',
        letterSpacing: '0.014000000208616257px',
        textDecoration: 'none',
        lineHeight: '150%',
        textTransform: 'none',
      },
      'Subtitle 1': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '16px',
        letterSpacing: '0.024000000953674317px',
        textDecoration: 'none',
        lineHeight: '175%',
        textTransform: 'none',
      },
    },
    Components: {
      'Alert Title': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '16px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '139.9999976158142%',
        textTransform: 'none',
      },
      'Avatar Initials': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '20px',
        letterSpacing: '-0.1px',
        textDecoration: 'none',
        lineHeight: '20px',
        textTransform: 'none',
      },
      'Badge Label': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '12px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '20px',
        textTransform: 'none',
      },
      'Bottom Navigation Active Label': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '12px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '150%',
        textTransform: 'none',
      },
      'Button Font - Large': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '15px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '26px',
        textTransform: 'uppercase',
      },
      'Button Font - Medium': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '14px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '24px',
        textTransform: 'uppercase',
      },
      'Button Font - Small': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '13px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '22px',
        textTransform: 'uppercase',
      },
      Chip: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '13px',
        letterSpacing: '0.020799999535083772px',
        textDecoration: 'none',
        lineHeight: '18px',
        textTransform: 'none',
      },
      Helper: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '12px',
        letterSpacing: '0px',
        textDecoration: 'none',
        textTransform: 'none',
      },
      'Input Text': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '16px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '24px',
        textTransform: 'none',
      },
      Label: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '12px',
        letterSpacing: '0px',
        textDecoration: 'none',
        textTransform: 'none',
      },
      'List Subheader': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '14px',
        letterSpacing: '0.014000000208616257px',
        textDecoration: 'none',
        lineHeight: '48px',
        textTransform: 'none',
      },
      'Menu Item': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '14px',
        letterSpacing: '0px',
        textDecoration: 'none',
        lineHeight: '139.9999976158142%',
        textTransform: 'none',
      },
      'Menu Item Dense': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 400,
        fontSize: '14px',
        letterSpacing: '0.023800000250339508px',
        textDecoration: 'none',
        lineHeight: '24px',
        textTransform: 'none',
      },
      'Table Header': {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '14px',
        letterSpacing: '0.023800000250339508px',
        textDecoration: 'none',
        lineHeight: '24px',
        textTransform: 'none',
      },
      Tooltip: {
        fontStyle: 'normal',
        fontFamily: 'Inter',
        fontWeight: 500,
        fontSize: '12px',
        letterSpacing: '0px',
        textDecoration: 'none',
        textTransform: 'none',
      },
    },
  },
  customShadows: {
    buttonShadowPrimary: {
      boxShadow: '0px 3px 5px rgba(107, 104, 255, 0.5)',
    },
    buttonShadowWarning: {
      boxShadow: '0px 3px 5px rgba(208, 132, 43, 1)',
    },
    buttonShadowError: {
      boxShadow: '0px 3px 5px rgba(246, 59, 115, 0.5)',
    },
    buttonShadowInfo: {
      boxShadow: '0px 3px 5px rgba(60, 111, 242, 0.6)',
    },
    buttonShadowSuccess: {
      boxShadow: '0px 3px 5px rgba(18, 157, 32, 0.6)',
    },
    switchShadow: {
      boxShadow: '0px 1px 2px rgba(0, 0, 0, 0.3)',
    },
    cardShadow: {
      boxShadow: '0px 6px 16px rgba(0, 0, 0, 0.17)',
    },
    'Outlined Light': {
      boxShadow: '0px 0px 0px rgba(211, 211, 211, 0.9)',
    },
    'Outlined Dark': {
      boxShadow: '0px 0px 0px rgba(255, 255, 255, 0.3)',
    },
  },
} as any);

const darkQuestTheme = createTheme(
  {
    components: {
      MuiButtonBase: {
        defaultProps: {
          disableRipple: true,
        },
      },
      MuiAlert: {
        defaultProps: {
          iconMapping: {
            error: <SvgIcon component={IconInfo} />,
            warning: <SvgIcon component={IconAlert} />,
            info: <SvgIcon component={IconInfo1} />,
            success: <SvgIcon component={IconSuccess} />,
          },
        },
        styleOverrides: {
          filledError: {
            backgroundColor: darkGlobalTheme.palette['Error']['Main'],
            borderRadius: `4px`,
          },
          filledWarning: {
            backgroundColor: darkGlobalTheme.palette['Warning']['Main'],
            borderRadius: `4px`,
          },
          filledInfo: {
            backgroundColor: darkGlobalTheme.palette['Info']['Main'],
            borderRadius: `4px`,
          },
          filledSuccess: {
            backgroundColor: darkGlobalTheme.palette['Success']['Main'],
            borderRadius: `4px`,
          },
        },
      },
      MuiAvatar: {
        styleOverrides: {
          rounded: {
            borderRadius: `4px`,
          },
          square: {},
          circular: {},
          colorDefault: {
            color: darkGlobalTheme.palette['Text']['Secondary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Avatar Initials']
                .textTransform,
          },
        },
      },
      MuiButton: {
        styleOverrides: {
          containedSizeLarge: {
            padding: `8px 22px`,
            borderRadius: `4px`,
            height: `42px`,
          },
          containedSizeMedium: {
            padding: `6px 16px`,
            borderRadius: `4px`,
            height: `36px`,
          },
          containedSizeSmall: {
            padding: `4px 12px`,
            borderRadius: `4px`,
            height: `30px`,
          },
          containedPrimary: {
            backgroundColor: darkGlobalTheme.palette['Primary']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(0, 0, 0, 0.9)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Primary']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(0, 0, 0, 0.9)`,
            },
            '&:disabled': {
              backgroundColor:
                darkGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          containedSecondary: {
            backgroundColor: darkGlobalTheme.palette['Secondary']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(0, 0, 0, 0.9)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Secondary']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(0, 0, 0, 0.9)`,
            },
            '&:disabled': {
              backgroundColor:
                darkGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          containedError: {
            backgroundColor: darkGlobalTheme.palette['Error']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(0, 0, 0, 0.9)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Error']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(0, 0, 0, 0.9)`,
            },
            '&:disabled': {
              backgroundColor:
                darkGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          containedSuccess: {
            backgroundColor: darkGlobalTheme.palette['Success']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(0, 0, 0, 0.9)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Success']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(0, 0, 0, 0.9)`,
            },
            '&:disabled': {
              backgroundColor:
                darkGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          containedInfo: {
            backgroundColor: darkGlobalTheme.palette['Info']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(0, 0, 0, 0.9)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Info']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(0, 0, 0, 0.9)`,
            },
            '&:disabled': {
              backgroundColor:
                darkGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          containedWarning: {
            backgroundColor: darkGlobalTheme.palette['Warning']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(0, 0, 0, 0.9)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Warning']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(0, 0, 0, 0.9)`,
            },
            '&:disabled': {
              backgroundColor:
                darkGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          outlinedSizeLarge: {
            padding: `8px 22px`,
            borderRadius: `4px`,
            height: `42px`,
          },
          outlinedSizeMedium: {
            padding: `6px 16px`,
            borderRadius: `4px`,
            height: `36px`,
          },
          outlinedSizeSmall: {
            padding: `4px 12px`,
            borderRadius: `4px`,
            height: `30px`,
          },
          outlinedPrimary: {
            border: `1px solid rgba(107, 104, 255, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(208, 207, 246, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Primary']['Shades']['8p'],
              border: `1px solid rgba(107, 104, 255, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(208, 207, 246, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          outlinedSecondary: {
            border: `1px solid rgba(38, 196, 246, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(194, 238, 252, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Secondary']['Shades']['8p'],
              border: `1px solid rgba(38, 196, 246, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(194, 238, 252, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          outlinedError: {
            border: `1px solid rgba(233, 78, 124, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(249, 206, 219, 1)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Error']['Shades']['8p'],
              border: `1px solid rgba(233, 78, 124, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(249, 206, 219, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          outlinedSuccess: {
            border: `1px solid rgba(100, 207, 111, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(205, 239, 208, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Success']['Shades']['8p'],
              border: `1px solid rgba(100, 207, 111, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(205, 239, 208, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          outlinedInfo: {
            border: `1px solid rgba(83, 177, 245, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(205, 232, 252, 1)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Info']['Shades']['8p'],
              border: `1px solid rgba(83, 177, 245, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(205, 232, 252, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          outlinedWarning: {
            border: `1px solid rgba(245, 161, 83, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(251, 220, 191, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Warning']['Shades']['8p'],
              border: `1px solid rgba(245, 161, 83, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(251, 220, 191, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          textSizeLarge: {
            padding: `8px 22px`,
            borderRadius: `4px`,
            height: `42px`,
          },
          textSizeMedium: {
            padding: `6px 16px`,
            borderRadius: `4px`,
            height: `36px`,
          },
          textSizeSmall: {
            padding: `4px 12px`,
            borderRadius: `4px`,
            height: `30px`,
          },
          textPrimary: {
            color: `rgba(208, 207, 246, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Primary']['Shades']['8p'],
              color: `rgba(208, 207, 246, 1)`,
            },
            '&:disabled': {
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          textSecondary: {
            color: `rgba(194, 238, 252, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Secondary']['Shades']['8p'],
              color: `rgba(194, 238, 252, 1)`,
            },
            '&:disabled': {
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          textError: {
            color: `rgba(249, 206, 219, 1)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Error']['Shades']['8p'],
              color: `rgba(249, 206, 219, 1)`,
            },
            '&:disabled': {
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          textSuccess: {
            color: `rgba(205, 239, 208, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Success']['Shades']['8p'],
              color: `rgba(205, 239, 208, 1)`,
            },
            '&:disabled': {
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          textInfo: {
            color: `rgba(205, 232, 252, 1)`,
            '&:hover': {
              backgroundColor: darkGlobalTheme.palette['Info']['Shades']['8p'],
              color: `rgba(205, 232, 252, 1)`,
            },
            '&:disabled': {
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
          textWarning: {
            color: `rgba(251, 220, 191, 1)`,
            '&:hover': {
              backgroundColor:
                darkGlobalTheme.palette['Warning']['Shades']['8p'],
              color: `rgba(251, 220, 191, 1)`,
            },
            '&:disabled': {
              color: `rgba(255, 255, 255, 0.42)`,
            },
          },
        },
      },
      MuiCheckbox: {
        defaultProps: {
          icon: <SvgIcon component={IconUnchecked} />,
          checkedIcon: <SvgIcon component={IconChecked} />,
          indeterminateIcon: <SvgIcon component={IconMixed} />,
        },
        styleOverrides: {
          root: {
            '&:hover': {
              borderRadius: `0px`,
            },
          },
        },
      },
      MuiFormControlLabel: {
        styleOverrides: {
          label: {
            '&.Mui-disabled': {},
          },
          root: {
            marginLeft: '0px',
          },
        },
      },
      MuiSwitch: {
        styleOverrides: {
          switchBase: {
            '&.MuiSwitch-colorPrimary': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(208, 207, 246, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorSecondary': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(194, 238, 252, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorError': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(249, 206, 219, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorWarning': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(251, 220, 191, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorSuccess': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(205, 239, 208, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorInfo': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(205, 232, 252, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
          },
          track: {
            '.MuiSwitch-colorPrimary + &': {
              backgroundColor: 'rgba(255, 255, 255, 0.3)',
            },
            '.MuiSwitch-colorSecondary + &': {
              backgroundColor: 'rgba(255, 255, 255, 0.3)',
            },
            '.MuiSwitch-colorError + &': {
              backgroundColor: 'rgba(255, 255, 255, 0.3)',
            },
            '.MuiSwitch-colorWarning + &': {
              backgroundColor: 'rgba(255, 255, 255, 0.3)',
            },
            '.MuiSwitch-colorSuccess + &': {
              backgroundColor: 'rgba(255, 255, 255, 0.3)',
            },
            '.MuiSwitch-colorInfo + &': {
              backgroundColor: 'rgba(255, 255, 255, 0.3)',
            },
          },
        },
      },
      MuiInput: {
        styleOverrides: {
          root: {
            color: darkGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Input Text'].fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Input Text'].fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Input Text'].lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
          sizeSmall: {
            color: darkGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Input Text'].fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Input Text'].fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Input Text'].lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
        },
      },
      MuiFormHelperText: {
        styleOverrides: {
          root: {
            '&.MuiError': {},
          },
        },
      },
      MuiInputLabel: {
        styleOverrides: {
          root: {},
          sizeSmall: {
            color: darkGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Input Text'].fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Input Text'].fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Input Text'].lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
        },
      },
      MuiFilledInput: {
        styleOverrides: {
          root: {
            color: darkGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Input Text'].fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Input Text'].fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Input Text'].lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
          sizeSmall: {
            color: darkGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Input Text'].fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Input Text'].fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Input Text'].lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
        },
      },
      MuiOutlinedInput: {
        styleOverrides: {
          root: {
            color: darkGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Input Text'].fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Input Text'].fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Input Text'].lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
          sizeSmall: {
            color: darkGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              darkGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              darkGlobalTheme.typography['Components']['Input Text'].fontFamily,
            fontWeight:
              darkGlobalTheme.typography['Components']['Input Text'].fontWeight,
            fontSize:
              darkGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              darkGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              darkGlobalTheme.typography['Components']['Input Text'].lineHeight,
            textDecoration:
              darkGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              darkGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
        },
      },
    },
  },
  darkGlobalTheme
);

export default darkQuestTheme;
