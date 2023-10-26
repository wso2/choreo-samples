import React from 'react';

import { createTheme } from '@mui/material/styles';

import SvgIcon from '@mui/material/SvgIcon';

import { ReactComponent as IconAlert } from 'src/assets/images/_IconAlert_1.svg';
import { ReactComponent as IconAlert1 } from 'src/assets/images/_IconAlert_1.svg';
import { ReactComponent as IconInfo } from 'src/assets/images/_IconInfo.svg';
import { ReactComponent as IconSuccess } from 'src/assets/images/_IconSuccess.svg';
import { ReactComponent as IconUnchecked } from 'src/assets/images/_IconUnchecked.svg';
import { ReactComponent as IconChecked } from 'src/assets/images/_IconChecked.svg';
import { ReactComponent as IconMixed } from 'src/assets/images/_IconMixed.svg';

const lightGlobalTheme: any = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: 'rgba(55, 99, 255, 1)',
      contrastText: 'rgba(255, 255, 255, 1)',
    },
    secondary: {
      main: 'rgba(38, 196, 246, 1)',
      contrastText: 'rgba(255, 255, 255, 1)',
    },
    error: {
      main: 'rgba(233, 78, 124, 1)',
      contrastText: 'rgba(255, 255, 255, 1)',
    },
    warning: {
      main: 'rgba(247, 153, 66, 1)',
      contrastText: 'rgba(255, 255, 255, 1)',
    },
    success: {
      main: 'rgba(85, 200, 97, 1)',
      contrastText: 'rgba(255, 255, 255, 1)',
    },
    info: {
      main: 'rgba(79, 177, 249, 1)',
      contrastText: 'rgba(255, 255, 255, 1)',
    },
    text: {
      primary: 'rgba(0, 0, 0, 1)',
      secondary: 'rgba(85, 85, 85, 1)',
      disabled: 'rgba(176, 176, 176, 1)',
    },
    action: {
      active: 'rgba(0, 0, 0, 0.54)',
      selected: 'rgba(0, 0, 0, 0.08)',
      focus: 'rgba(0, 0, 0, 0.12)',
    },
    Primary: {
      Main: 'rgba(55, 99, 255, 1)',
      Contrast: 'rgba(255, 255, 255, 1)',
      Shades: {
        '4p': 'rgba(107, 104, 255, 0.04)',
        '8p': 'rgba(107, 104, 255, 0.08)',
        '12p': 'rgba(107, 104, 255, 0.12)',
        '30p': 'rgba(107, 104, 255, 0.3)',
        '50p': 'rgba(107, 104, 255, 0.5)',
      },
    },
    Secondary: {
      Main: 'rgba(38, 196, 246, 1)',
      Contrast: 'rgba(255, 255, 255, 1)',
      Shades: {
        '4p': 'rgba(38, 196, 246, 0.04)',
        '8p': 'rgba(38, 196, 246, 0.08)',
        '12p': 'rgba(38, 196, 246, 0.12)',
        '30p': 'rgba(38, 196, 246, 0.3)',
        '50p': 'rgba(38, 196, 246, 0.5)',
      },
    },
    Error: {
      Main: 'rgba(233, 78, 124, 1)',
      Contrast: 'rgba(255, 255, 255, 1)',
      Shades: {
        '4p': 'rgba(233, 78, 124, 0.04)',
        '8p': 'rgba(233, 78, 124, 0.08)',
        '12p': 'rgba(233, 78, 124, 0.12)',
        '30p': 'rgba(233, 78, 124, 0.3)',
        '50p': 'rgba(233, 78, 124, 0.5)',
      },
    },
    Warning: {
      Main: 'rgba(247, 153, 66, 1)',
      Contrast: 'rgba(255, 255, 255, 1)',
      Shades: {
        '4p': 'rgba(245, 161, 83, 0.04)',
        '8p': 'rgba(245, 161, 83, 0.08)',
        '12p': 'rgba(245, 161, 83, 0.12)',
        '30p': 'rgba(245, 161, 83, 0.3)',
        '50p': 'rgba(245, 161, 83, 0.5)',
      },
    },
    Info: {
      Main: 'rgba(79, 177, 249, 1)',
      Contrast: 'rgba(255, 255, 255, 1)',
      Shades: {
        '4p': 'rgba(83, 177, 245, 0.04)',
        '8p': 'rgba(83, 177, 245, 0.08)',
        '12p': 'rgba(83, 177, 245, 0.12)',
        '30p': 'rgba(83, 177, 245, 0.3)',
        '50p': 'rgba(83, 177, 245, 0.5)',
      },
    },
    Success: {
      Main: 'rgba(85, 200, 97, 1)',
      Contrast: 'rgba(255, 255, 255, 1)',
      Shades: {
        '4p': 'rgba(100, 207, 111, 0.04)',
        '8p': 'rgba(100, 207, 111, 0.08)',
        '12p': 'rgba(100, 207, 111, 0.12)',
        '30p': 'rgba(100, 207, 111, 0.3)',
        '50p': 'rgba(100, 207, 111, 0.5)',
      },
    },
    Text: {
      Primary: 'rgba(0, 0, 0, 1)',
      Secondary: 'rgba(85, 85, 85, 1)',
      Disabled: 'rgba(176, 176, 176, 1)',
    },
    Action: {
      'Active (54p)': 'rgba(0, 0, 0, 0.54)',
      Hover: 'rgba(0, 0, 0, 0.04)',
      'Selected (8p)': 'rgba(0, 0, 0, 0.08)',
      Disabled: 'rgba(0, 0, 0, 0.26)',
      'Disabled Background': 'rgba(0, 0, 0, 0.12)',
      'Focus (12p)': 'rgba(0, 0, 0, 0.12)',
    },
    Background: {
      Background: 'rgba(254, 254, 254, 1)',
      Paper: 'rgba(255, 255, 255, 1)',
    },
    Other: {
      Divider: 'rgba(243, 243, 243, 1)',
      'Border (23p)': 'rgba(0, 0, 0, 0.23)',
      'Backdrop Overlay': 'rgba(0, 0, 0, 0.5)',
      'Standard Input Line': 'rgba(0, 0, 0, 0.42)',
      'Filled Input Background': 'rgba(0, 0, 0, 0.1)',
      Snackbar: 'rgba(50, 50, 50, 1)',
      Tooltip: 'rgba(44, 44, 44, 1)',
      'Rating Active': 'rgba(245, 196, 21, 1)',
      'focus-ring-color': 'rgba(87, 54, 255, 1)',
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

const lightQuestTheme = createTheme(
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
            error: <SvgIcon component={IconAlert} />,
            warning: <SvgIcon component={IconAlert1} />,
            info: <SvgIcon component={IconInfo} />,
            success: <SvgIcon component={IconSuccess} />,
          },
        },
        styleOverrides: {
          filledError: {
            backgroundColor: lightGlobalTheme.palette['Error']['Main'],
            borderRadius: `4px`,
          },
          filledWarning: {
            backgroundColor: lightGlobalTheme.palette['Warning']['Main'],
            borderRadius: `4px`,
          },
          filledInfo: {
            backgroundColor: lightGlobalTheme.palette['Info']['Main'],
            borderRadius: `4px`,
          },
          filledSuccess: {
            backgroundColor: lightGlobalTheme.palette['Success']['Main'],
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
            color: lightGlobalTheme.palette['Text']['Secondary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Avatar Initials']
                .fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Avatar Initials']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Avatar Initials']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Avatar Initials']
                .fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Avatar Initials']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Avatar Initials']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Avatar Initials']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Avatar Initials']
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
            backgroundColor: lightGlobalTheme.palette['Primary']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(255, 255, 255, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Primary']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(255, 255, 255, 1)`,
            },
            '&:disabled': {
              backgroundColor:
                lightGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          containedSecondary: {
            backgroundColor: lightGlobalTheme.palette['Secondary']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(255, 255, 255, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Secondary']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(255, 255, 255, 1)`,
            },
            '&:disabled': {
              backgroundColor:
                lightGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          containedError: {
            backgroundColor: lightGlobalTheme.palette['Error']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(255, 255, 255, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Error']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(255, 255, 255, 1)`,
            },
            '&:disabled': {
              backgroundColor:
                lightGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          containedSuccess: {
            backgroundColor: lightGlobalTheme.palette['Success']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(255, 255, 255, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Success']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(255, 255, 255, 1)`,
            },
            '&:disabled': {
              backgroundColor:
                lightGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          containedInfo: {
            backgroundColor: lightGlobalTheme.palette['Info']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(255, 255, 255, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Secondary']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(255, 255, 255, 1)`,
            },
            '&:disabled': {
              backgroundColor:
                lightGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          containedWarning: {
            backgroundColor: lightGlobalTheme.palette['Warning']['Main'],
            boxShadow: `0px 1px 5px rgba(0, 0, 0, 0.12), 0px 2px 2px rgba(0, 0, 0, 0.14), 0px 3px 1px rgba(0, 0, 0, 0.2)`,
            color: `rgba(255, 255, 255, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Warning']['Dark'],
              boxShadow: `0px 1px 10px rgba(0, 0, 0, 0.12), 0px 4px 5px rgba(0, 0, 0, 0.14), 0px 2px 4px rgba(0, 0, 0, 0.2)`,
              color: `rgba(255, 255, 255, 1)`,
            },
            '&:disabled': {
              backgroundColor:
                lightGlobalTheme.palette['Action']['Disabled Background'],
              color: `rgba(0, 0, 0, 0.26)`,
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
            color: `rgba(55, 99, 255, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Primary']['Shades']['4p'],
              border: `1px solid rgba(107, 104, 255, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(55, 99, 255, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          outlinedSecondary: {
            border: `1px solid rgba(38, 196, 246, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(38, 196, 246, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Secondary']['Shades']['4p'],
              border: `1px solid rgba(38, 196, 246, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(38, 196, 246, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          outlinedError: {
            border: `1px solid rgba(233, 78, 124, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(233, 78, 124, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Error']['Shades']['4p'],
              border: `1px solid rgba(233, 78, 124, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(233, 78, 124, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          outlinedSuccess: {
            border: `1px solid rgba(100, 207, 111, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(85, 200, 97, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Success']['Shades']['4p'],
              border: `1px solid rgba(100, 207, 111, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(85, 200, 97, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          outlinedInfo: {
            border: `1px solid rgba(83, 177, 245, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(79, 177, 249, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Info']['Shades']['4p'],
              border: `1px solid rgba(83, 177, 245, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(79, 177, 249, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          outlinedWarning: {
            border: `1px solid rgba(245, 161, 83, 0.5)`,
            boxSizing: `border-box`,
            color: `rgba(247, 153, 66, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Warning']['Shades']['4p'],
              border: `1px solid rgba(245, 161, 83, 0.5)`,
              boxSizing: `border-box`,
              color: `rgba(247, 153, 66, 1)`,
            },
            '&:disabled': {
              border: `1px solid rgba(0, 0, 0, 0.12)`,
              boxSizing: `border-box`,
              color: `rgba(0, 0, 0, 0.26)`,
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
            color: `rgba(55, 99, 255, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Primary']['Shades']['4p'],
              color: `rgba(55, 99, 255, 1)`,
            },
            '&:disabled': {
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          textSecondary: {
            color: `rgba(38, 196, 246, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Secondary']['Shades']['4p'],
              color: `rgba(38, 196, 246, 1)`,
            },
            '&:disabled': {
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          textError: {
            color: `rgba(233, 78, 124, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Error']['Shades']['4p'],
              color: `rgba(233, 78, 124, 1)`,
            },
            '&:disabled': {
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          textSuccess: {
            color: `rgba(85, 200, 97, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Success']['Shades']['4p'],
              color: `rgba(85, 200, 97, 1)`,
            },
            '&:disabled': {
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          textInfo: {
            color: `rgba(79, 177, 249, 1)`,
            '&:hover': {
              backgroundColor: lightGlobalTheme.palette['Info']['Shades']['4p'],
              color: `rgba(79, 177, 249, 1)`,
            },
            '&:disabled': {
              color: `rgba(0, 0, 0, 0.26)`,
            },
          },
          textWarning: {
            color: `rgba(247, 153, 66, 1)`,
            '&:hover': {
              backgroundColor:
                lightGlobalTheme.palette['Warning']['Shades']['4p'],
              color: `rgba(247, 153, 66, 1)`,
            },
            '&:disabled': {
              color: `rgba(0, 0, 0, 0.26)`,
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
                color: 'rgba(55, 99, 255, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorSecondary': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(38, 196, 246, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorError': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(233, 78, 124, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorWarning': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(247, 153, 66, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorSuccess': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(85, 200, 97, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
            '&.MuiSwitch-colorInfo': {
              color: 'rgba(254, 254, 254, 1)',
              '&.Mui-checked': {
                color: 'rgba(79, 177, 249, 1)',
                '&:hover': {
                  backgroundColor: 'undefined',
                },
              },
            },
          },
          track: {
            '.MuiSwitch-colorPrimary + &': {
              backgroundColor: 'rgba(0, 0, 0, 0.3)',
            },
            '.MuiSwitch-colorSecondary + &': {
              backgroundColor: 'rgba(0, 0, 0, 0.3)',
            },
            '.MuiSwitch-colorError + &': {
              backgroundColor: 'rgba(0, 0, 0, 0.3)',
            },
            '.MuiSwitch-colorWarning + &': {
              backgroundColor: 'rgba(0, 0, 0, 0.3)',
            },
            '.MuiSwitch-colorSuccess + &': {
              backgroundColor: 'rgba(0, 0, 0, 0.3)',
            },
            '.MuiSwitch-colorInfo + &': {
              backgroundColor: 'rgba(0, 0, 0, 0.3)',
            },
          },
        },
      },
      MuiInput: {
        styleOverrides: {
          root: {
            color: lightGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
          sizeSmall: {
            color: lightGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Input Text']
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
            color: lightGlobalTheme.palette['Text']['Secondary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
        },
      },
      MuiFilledInput: {
        styleOverrides: {
          root: {
            color: lightGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
          sizeSmall: {
            color: lightGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
        },
      },
      MuiOutlinedInput: {
        styleOverrides: {
          root: {
            color: lightGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
          sizeSmall: {
            color: lightGlobalTheme.palette['Text']['Primary'],
            fontStyle:
              lightGlobalTheme.typography['Components']['Input Text'].fontStyle,
            fontFamily:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontFamily,
            fontWeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .fontWeight,
            fontSize:
              lightGlobalTheme.typography['Components']['Input Text'].fontSize,
            letterSpacing:
              lightGlobalTheme.typography['Components']['Input Text']
                .letterSpacing,
            lineHeight:
              lightGlobalTheme.typography['Components']['Input Text']
                .lineHeight,
            textDecoration:
              lightGlobalTheme.typography['Components']['Input Text']
                .textDecoration,
            textTransform:
              lightGlobalTheme.typography['Components']['Input Text']
                .textTransform,
          },
        },
      },
    },
  },
  lightGlobalTheme
);

export default lightQuestTheme;
