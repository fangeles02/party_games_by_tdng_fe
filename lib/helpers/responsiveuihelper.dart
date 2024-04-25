class ResponsiveUiHelper {
  bool isSmallScreen(double width) {
    if (width > 0 && width <= 768) {
      return true;
    } else {
      return false;
    }
  }

  bool isMediumScreen(double width) {
    if (width > 768 && width <= 992) {
      return true;
    } else {
      return false;
    }
  }

  bool isLargeScreen(double width) {
    if (width > 992) {
      return true;
    } else {
      return false;
    }
  }
}

double smallScreenPadding = 20;
double mediumScreenPadding = 50;
double largeScreenPadding = 70;
