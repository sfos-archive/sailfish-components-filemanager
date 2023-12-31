Name:       sailfish-components-filemanager
Summary:    Sailfish File Manager UI components
Version:    0.2.24
Release:    1
License:    BSD
URL:        https://github.com/sailfishos/sailfish-components-filemanager
Source0:    %{name}-%{version}.tar.bz2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Gui)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  qt5-qttools
BuildRequires:  qt5-qttools-linguist

Requires: sailfishsilica-qt5 >= 1.1.75
Requires: sailfish-content-graphics
Requires: nemo-qml-plugin-filemanager >= 0.1.30
Requires: nemo-qml-plugin-notifications-qt5

%description
%{summary}.

%package ts-devel
Summary:   Translation source for sailfish-components-filemanager

%description ts-devel
%{summary}.

%prep
%setup -q -n %{name}-%{version}

%build

%qmake5

make %{_smp_mflags}

%install
rm -rf %{buildroot}

%qmake5_install

%files
%defattr(-,root,root,-)
%license LICENSE.BSD
%{_libdir}/qt5/qml/Sailfish/FileManager
%{_datadir}/translations/sailfish_components_filemanager_eng_en.qm

%files ts-devel
%defattr(-,root,root,-)
%{_datadir}/translations/source/sailfish_components_filemanager.ts
